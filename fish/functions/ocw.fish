function ocw --description "Manage the persistent opencode web service (launchd + Tailscale)"
    set -l label com.(id -un).opencode-web
    set -l tpl_src $HOME/dotfiles/scripts/macos/opencode-web.plist.template
    set -l plist_dst $HOME/Library/LaunchAgents/$label.plist
    set -l sub $argv[1]

    switch "$sub"
        case status ''
            set -l line (launchctl list | grep -F $label)
            if test -n "$line"
                set -l pid (echo $line | awk '{print $1}')
                echo "● running  (pid $pid)"
            else
                echo "○ stopped  (not loaded)"
            end
        case start
            launchctl kickstart -k gui/(id -u)/$label
        case stop
            launchctl kill SIGTERM gui/(id -u)/$label
        case restart
            launchctl kickstart -k gui/(id -u)/$label
        case enable
            launchctl enable gui/(id -u)/$label
        case disable
            launchctl disable gui/(id -u)/$label
        case log
            tail -f $HOME/Library/Logs/opencode-web.log $HOME/Library/Logs/opencode-web.err.log
        case url
            set -l hn (tailscale status --json 2>/dev/null | jq -r '.Self.DNSName // empty' | sed 's/\.$//')
            if test -n "$hn"
                echo "https://$hn"
            else
                echo "https://(tailscale-ip):4096 (tailscale not running?)"
            end
        case install
            if not test -f $tpl_src
                echo "missing $tpl_src" >&2
                return 1
            end
            mkdir -p $HOME/Library/LaunchAgents
            sed -e "s|__LABEL__|$label|g" \
                -e "s|__HOME__|$HOME|g" \
                -e "s|__DOTFILES__|$HOME/dotfiles|g" \
                $tpl_src > $plist_dst
            launchctl bootstrap gui/(id -u) $plist_dst 2>/dev/null
            launchctl enable gui/(id -u)/$label 2>/dev/null
            launchctl kickstart -k gui/(id -u)/$label
            if command -q tailscale
                set -l port (set -q OPENCODE_SERVER_PORT; and echo $OPENCODE_SERVER_PORT; or echo 4096)
                tailscale serve --bg "http://127.0.0.1:$port" 2>/dev/null
                and echo "tailscale serve configured" || echo "tailscale serve skipped (run manually)"
            end
            echo "installed + started. URL: "(ocw url)
        case uninstall
            launchctl bootout gui/(id -u)/$label 2>/dev/null
            rm -f $plist_dst
            echo "uninstalled"
        case '-h' '--help'
            echo "usage: ocw {status|start|stop|restart|enable|disable|log|url|install|uninstall}"
        case '*'
            echo "unknown subcommand: $sub" >&2
            return 1
    end
end

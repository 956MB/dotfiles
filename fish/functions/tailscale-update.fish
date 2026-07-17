function tailscale-update --description 'Update Tailscale via Homebrew and restart the daemon (macOS)'
    if test (uname) != Darwin
        echo "tailscale-update is macOS-only" >&2
        return 1
    end

    if not type -q brew
        echo "Homebrew is required" >&2
        return 1
    end

    set -l dead_tap robotsandpencils/made
    if brew tap 2>/dev/null | string match -q -e $dead_tap
        echo "Removing dead tap: $dead_tap"
        brew untap $dead_tap
    end

    brew update
    or return

    brew upgrade tailscale
    or return

    set -l ts_pid (command ps -axo pid=,user=,comm= 2>/dev/null | command awk '$3 == "tailscaled" && $2 == "root" { print $1; exit }')
    if test -n "$ts_pid"
        echo "Stopping root-owned tailscaled (pid $ts_pid)..."
        if not command -q osascript
            echo "osascript is required to restart a root-owned tailscaled" >&2
            return 1
        end
        osascript -e 'do shell script "kill '"$ts_pid"'" with administrator privileges' >/dev/null 2>&1
        if test $status -ne 0
            echo "Failed to stop tailscaled (user cancelled the admin prompt?)" >&2
            return 1
        end
        command sleep 2
    end

    brew services start tailscale
    or return

    command sleep 1

    set -l current /opt/homebrew/opt/tailscale/bin/tailscaled
    set -l sfw /usr/libexec/ApplicationFirewall/socketfilterfw
    if test -x $current; and test -x $sfw
        for old in ($sfw --listapps 2>/dev/null | command grep -E '/Cellar/tailscale/[^/]+/bin/tailscaled$' | string trim)
            $sfw --remove $old >/dev/null 2>&1
        end
        if not $sfw --listapps 2>/dev/null | command grep -qF $current
            $sfw --add $current >/dev/null 2>&1
        end
    end

    set -l client_ver
    set -l server_ver
    if type -q tailscale
        set client_ver (tailscale version 2>/dev/null | command head -1 | string trim)
        set server_ver (tailscale status 2>&1 | command head -1 | string match -r 'server version "([^"]+)"')
    end

    echo ""
    echo "==> Tailscale updated"
    echo "  client: $client_ver"
    if test -n "$server_ver"
        echo "  server: $server_ver"
    end

    if command brew cleanup tailscale >/dev/null 2>&1
        echo "  old kegs: reaped"
    end
end

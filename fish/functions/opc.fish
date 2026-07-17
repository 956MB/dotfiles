function opc --description "Attach TUI to running opencode web service (or specific session)"
    set -l password (security find-generic-password -s opencode-server -a opencode -w 2>/dev/null)
    if test -z "$password"
        echo "Error: No opencode-server password in Keychain. Store it with:" >&2
        echo "  security add-generic-password -s opencode-server -a opencode -w <password>" >&2
        return 1
    end

    set -l username opencode
    if set -q OPENCODE_SERVER_USERNAME
        set username $OPENCODE_SERVER_USERNAME
    end

    set -l args http://127.0.0.1:4096 --dir "$PWD"
    if set -q argv[1]
        set args $args --session $argv[1]
    end

    OPENCODE_SERVER_PASSWORD="$password" OPENCODE_SERVER_USERNAME="$username" command opencode attach $args
end

function fish_command_not_found
    if test -f package.json
        if jq -e ".scripts | has(\"$argv[1]\")" package.json >/dev/null 2>&1
            bun run $argv
            return 0
        end
    end
    __fish_default_command_not_found_handler $argv
end

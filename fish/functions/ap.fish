function ap --description "Print alias definition"
    if test (count $argv) -eq 0
        echo "Usage: ap <alias_name>"
        return 1
    end

    set -l alias_def (alias $argv[1] 2>/dev/null)
    if test $status -eq 0
        echo "$argv[1] -> $alias_def"
    else
        echo "Alias '$argv[1]' not found"
    end
end

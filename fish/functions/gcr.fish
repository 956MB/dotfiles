function gcr
    if test (count $argv) -eq 0
        return 1
    end

    if string match -q -r '^(https|git@github\.com)' $argv[1]
        if test (count $argv) -ge 2
            git clone $argv[1] $argv[2]
        else
            git clone $argv[1]
        end
    else
        if test (count $argv) -ge 2
            gh repo clone $argv[1] $argv[2]
        else
            gh repo clone $argv[1]
        end
    end
end

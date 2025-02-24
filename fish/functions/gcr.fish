function gcr
    if test (count $argv) -eq 0
        return 1
    end
    
    if string match -q -r '^(https|git@github\.com)' $argv[1]
        git clone $argv[1]
    else
        gh repo clone $argv[1]
    end
end 

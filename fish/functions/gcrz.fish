function gcrz
    if test (count $argv) -eq 0
        return 1
    end
    
    set repo_dir ""
    if test (count $argv) -ge 2
        set repo_dir $argv[2]
    else
        if string match -q -r '^(https|git@github\.com)' $argv[1]
            set repo_dir (string replace -r '.*/' '' $argv[1] | string replace -r '\.git$' '')
        else
            set repo_dir (string replace -r '.*/' '' $argv[1])
        end
    end
    
    gcr $argv
    
    if test $status -eq 0 -a -d $repo_dir
        z $repo_dir
    end
end

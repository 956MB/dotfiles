function zsde --description "Delete all exited zellij sessions except those specified"
    set -l exclude_pattern $argv[1]

    if test -z "$exclude_pattern"
        set exclude_pattern "^$"
    end

    zellij ls -n | grep EXITED | grep -v "$exclude_pattern" | awk '{print $1}' | xargs -I {} zellij d {}
end

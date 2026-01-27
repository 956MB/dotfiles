function zellij_tab_name_update
    if not set -q ZELLIJ
        return
    end

    set -l parent_pid (ps -o ppid= -p %self | string trim)
    set -l parent_cmd (ps -o comm= -p $parent_pid 2>/dev/null | string trim)
    set -l persistent_programs nvim nv bat lg lazygit btop
    
    for prog in $persistent_programs
        if string match -q "*$prog*" "$parent_cmd"
            set -l tab_name (basename $parent_cmd)
            zellij action rename-tab "$tab_name" &>/dev/null &
            disown
            return
        end
    end

    set -l current_dir $PWD
    if test "$current_dir" = "$HOME"
        set -l tab_name "~"
    else
        set -l tab_name (basename $current_dir)
    end

    zellij action rename-tab "$tab_name" &>/dev/null &
    disown
end

function __zellij_on_pwd_change --on-variable PWD
    if set -q ZELLIJ
        zellij_tab_name_update
    end
end

function __zellij_on_preexec --on-event fish_preexec
    if not set -q ZELLIJ
        return
    end

    set -l cmd (string split " " -- $argv[1])[1]
    
    zellij action rename-tab "$cmd" &>/dev/null &
    disown
end

function __zellij_on_postexec --on-event fish_postexec
    if not set -q ZELLIJ
        return
    end

    set -l cmd (string split " " -- $argv[1])[1]
    set -l persistent_programs nvim nv bat lg lazygit btop
    
    for prog in $persistent_programs
        if test "$cmd" = "$prog"
            return
        end
    end

    set -l current_dir $PWD
    if test "$current_dir" = "$HOME"
        set -l tab_name "~"
    else
        set -l tab_name (basename $current_dir)
    end
    
    fish -c "sleep 0.05; zellij action rename-tab '$tab_name' &>/dev/null" &
    disown
end

if set -q ZELLIJ
    zellij_tab_name_update
end

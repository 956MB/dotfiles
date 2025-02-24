function fish_prompt
    set -l last_status $status
    
    # Current directory
    set_color --bold blue
    echo -n (string replace -r "^$HOME" "~" $PWD)
    set_color normal
    
    # Status code
    if test $last_status -ne 0
        echo -n ", "
        set_color red
        echo -n $last_status
        set_color normal
    end
    
    # Git information
    if git rev-parse --is-inside-work-tree 2>/dev/null >/dev/null
        echo -n " "
        set_color --bold magenta
        echo -n (git rev-parse --abbrev-ref HEAD 2>/dev/null)
        
        # Git status (modified files count)
        set -l git_status (git status --short | wc -l | string trim)
        if test $git_status -gt 0
            set_color --bold cyan
            echo -n "+$git_status"
        end
        set_color normal
    end
    
    # Timer (needs separate implementation)
    if set -q CMD_DURATION; and test $CMD_DURATION -gt 1000
        echo -n " "
        set_color yellow
        echo -n (math $CMD_DURATION / 1000)"s"
        set_color normal
    end
    
    # Sudo status
    if command sudo -n true 2>/dev/null
        echo -n " "
        set_color --bold red
        echo -n "SUDO"
        set_color normal
    end
    
    set_color white
    echo -n " : "
    set_color normal
end 

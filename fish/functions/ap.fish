function ap --description "Print alias definition"
    set -l red "\e[38;2;250;44;58m" # #FA2C3A
    set -l green "\e[38;2;91;155;76m" # #5B9B4C
    set -l purple "\e[38;2;197;134;192m" # #C586C0
    set -l yellow "\e[38;2;220;220;170m" # #DCDCAA
    set -l aqua "\e[38;2;78;201;176m" # #4EC9B0
    set -l reset "\e[0m"

    if test (count $argv) -eq 0
        echo -e "Usage: ap $aqua<alias_name>$reset"
        return 1
    end

    set -l al $argv[1]
    set -l alias_def (alias | grep -m 1 "^alias $al " | sed "s/^alias $al //")
    set -l alias_description (grep -m 1 "alias $al" ~/dotfiles/fish/conf.d/aliases.fish | grep -o "#.*" | sed 's/^# *//')

    if test -n "$alias_def"
        if test -n "$alias_description"
            echo -e "$aqua$al$reset -> $green$alias_def$reset $purple# $yellow$alias_description$reset"
        else
            echo -e "$aqua$al$reset -> $green$alias_def$reset"
        end
    else
        echo -e "Alias '$red$al$reset' not found"
    end
end

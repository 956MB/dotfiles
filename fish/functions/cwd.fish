function cwd
    set -l target .

    if test (count $argv) -gt 0
        set target $argv[1]
    end

    set -l path (realpath "$target")
    echo $path

    if test (uname) = Darwin
        printf '%s' "$path" | pbcopy
    else if type -q wl-copy
        printf '%s' "$path" | wl-copy
    else if type -q xclip
        printf '%s' "$path" | xclip -selection clipboard
    else if type -q xsel
        printf '%s' "$path" | xsel --clipboard --input
    end
end

complete -c cwd -f -a "(__fish_complete_directories)"

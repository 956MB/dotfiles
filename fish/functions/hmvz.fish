function hmvz --description 'Move the current directory to ~/Hoard/Forks and stay in it'
    if test (count $argv) -ne 0
        echo 'Usage: hmvz' >&2
        return 1
    end

    set -l current_dir (pwd)
    set -l repo_name (basename "$current_dir")
    set -l target_root "$HOME/Hoard/Forks"
    set -l target "$target_root/$repo_name"

    if test "$current_dir" = "$target"
        echo "Already in $target" >&2
        return 1
    end

    mkdir -p "$target_root"
    and mv "$current_dir" "$target_root"
    and z "$target"
end

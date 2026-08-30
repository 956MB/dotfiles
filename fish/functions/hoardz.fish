function hoardz --description 'Clone a repo into Hoard and z into it'
    if test (count $argv) -eq 0
        return 1
    end

    set -l repo_url (string replace -r '/+$' '' $argv[1])
    set -l repo_name (string replace -r '.*/' '' $repo_url | string replace -r '\.git$' '')
    set -l target_root "$HOME/Hoard/Saves"

    if string match -q -r '956MB' -- $repo_url
        set target_root "$HOME/Hoard/Forks"
    end

    set -l target "$target_root/$repo_name"
    mkdir -p "$target_root"
    and gcrz "$repo_url" "$target"
end

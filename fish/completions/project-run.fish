function __fish_project_scripts
    if test -f package.json
        jq -r '.scripts | keys[]' package.json 2>/dev/null
    end
end
complete -c "" -f -a "(__fish_project_scripts)" -d "npm script"

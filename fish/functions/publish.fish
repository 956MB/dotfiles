function publish --description "Initialize git repo and publish to GitHub"
    set -l visibility --private
    if test "$argv[1]" = "--public"
        set visibility --public
    end

    set -l repo_name (basename $PWD)

    if not test -d .git
        git init && git add -A && git commit -m "Init"
    end

    gh repo create "$repo_name" $visibility --source=. --remote=origin --push

    sleep 3
    git push -u origin main
end

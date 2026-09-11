function jcr
    if test (count $argv) -eq 0
        return 1
    end
    if string match -q -r '^(https://|git@|ssh://)' $argv[1]
        if test (count $argv) -ge 2
            jj git clone $argv[1] $argv[2]
        else
            jj git clone $argv[1]
        end
    else
        # gh-style shorthand (owner/repo) — resolve to a URL first so the
        # clone happens with jj directly instead of git
        set -l url (gh repo view $argv[1] --json url -q .url)
        if test $status -ne 0
            return 1
        end
        if test (count $argv) -ge 2
            jj git clone $url $argv[2]
        else
            jj git clone $url
        end
    end
end

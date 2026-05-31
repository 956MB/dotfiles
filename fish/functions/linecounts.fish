function linecounts --description 'List files sorted by line count, skipping large/generated dirs'
    set dir $argv[1] .
    find $dir \( -path '*/node_modules' \
        -o -path '*/.git' \
        -o -path '*/dist' \
        -o -path '*/build' \
        -o -path '*/.next' \
        -o -path '*/coverage' \
        -o -path '*/target' \
        -o -path '*/vendor' \
        -o -path '*/__pycache__' \
        -o -path '*/.cache' \
        -o -path '*/public/build' \
        -o -path '*.min.js' \
        -o -path '*.min.css' \
        -o -path '*/generated' \
        \) -prune -o -type f -print | while read -l f
        printf "%s\t%s\n" (wc -l < "$f") "$f"
    end | sort -n
end

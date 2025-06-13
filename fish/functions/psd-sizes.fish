function psd-sizes
    find . -type f -iname '*.psd' -print0 | xargs -0 stat -f "%z %N" | awk '
    {
        size_bytes = $1
        size_mb = size_bytes / 1024 / 1024
        size_gb = size_mb / 1024
        total += size_bytes
        if (size_gb >= 1) {
            printf "%8.4f GB  %s\n", size_gb, substr($0, index($0,$2))
        } else {
            printf "%8.2f MB  %s\n", size_mb, substr($0, index($0,$2))
        }
    }
    END {
        printf "\nTotal: %.4f GB\n", total / 1024 / 1024 / 1024
    }'
end

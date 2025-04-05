function fcs
    set total 0
    for dir in */ # List only top-level directories
        set count (find "$dir" -maxdepth 1 -type d ! -name ".*" | wc -l)
        set total (math "$total + $count - 1") # Subtract 1 to exclude $dir itself
    end
    echo $total
end

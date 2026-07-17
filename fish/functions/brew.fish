function brew --description "brew wrapper that mirrors installs/uninstalls into the Brewfile"
    set -l self (status filename)
    if command -q realpath
        set self (realpath $self)
    end
    set -l brewfile (string replace -r '/fish/functions/brew\.fish$' '' $self)
    set brewfile "$brewfile/Brewfile"

    if not test -f "$brewfile"
        command brew $argv
        return
    end

    set -l sub $argv[1]
    set -l rest $argv[2..-1]

    if not contains -- "$sub" install reinstall uninstall rm remove
        command brew $argv
        return
    end

    set -l is_uninstall false
    if contains -- "$sub" uninstall rm remove
        set is_uninstall true
    end

    set -l is_cask false
    set -l pkgs

    for token in $rest
        switch $token
            case --cask '--cask=*'
                set is_cask true
            case --force --force-bottle --HEAD --quiet --debug --verbose --ignore-dependencies --zap
                # known passthrough flags, skip
            case '-*'
                # unknown flag, skip
            case '*'
                set pkgs $pkgs $token
        end
    end

    if test (count $pkgs) -eq 0
        command brew $argv
        return
    end

    command brew $argv
    set -l brew_status $status

    if test $brew_status -ne 0
        return $brew_status
    end

    if test "$is_uninstall" = true
        set -l tmp (mktemp)
        set -l removed 0
        for pkg in $pkgs
            set -l pattern (string escape --style=regex "\"$pkg\"")
            set -l before (wc -l <$brewfile)
            command grep -vE "^[[:space:]]*(brew|cask)[[:space:]]+\"$pkg\"" $brewfile >$tmp
            set -l after (wc -l <$tmp)
            if test $after -lt $before
                mv $tmp $brewfile
                set removed (math $removed + 1)
                echo "  - removed \"$pkg\" from Brewfile"
            end
        end
        rm -f $tmp
        if test $removed -gt 0
            echo ""
            echo "Brewfile updated: $removed entr$(test $removed -eq 1 && echo y || echo ies) removed"
        end
        return $brew_status
    end

    set -l new_pkgs
    set -l new_taps
    for pkg in $pkgs
        if string match -q -r '/' $pkg
            set -l tap (string replace -r '/.*' '' $pkg)
            if not grep -q "^tap \"$tap\"" $brewfile
                set -a new_taps $tap
            end
        end

        if grep -qF "\"$pkg\"" $brewfile
            continue
        end
        set new_pkgs $new_pkgs $pkg
    end

    if test (count $new_pkgs) -eq 0; and test (count $new_taps) -eq 0
        return $brew_status
    end

    set -l marker "# >>> brew auto-tracked (review and reorder) <<<"
    if not grep -qF "$marker" $brewfile
        # insert the marker block right before the macOS-specific section
        set -l line_num (grep -n '^# macOS-specific' $brewfile | head -1 | cut -d: -f1)
        if test -n "$line_num"
            set -l tmp (mktemp)
            set -l n (math $line_num - 1)
            head -n $n $brewfile >$tmp
            echo $marker >>$tmp
            tail -n +$line_num $brewfile >>$tmp
            mv $tmp $brewfile
        else
            echo "" >>$brewfile
            echo $marker >>$brewfile
        end
    end

    set -l tmp (mktemp)
    set -l cross_platform_casks zen
    for tap in $new_taps
        echo "tap \"$tap\""
    end
    for pkg in $new_pkgs
        if test "$is_cask" = true
            if contains -- $pkg $cross_platform_casks
                echo "cask \"$pkg\""
            else
                echo "cask \"$pkg\" if OS.mac?"
            end
        else
            echo "brew \"$pkg\""
        end
    end | sort -u >>$tmp

    awk -v insert_file="$tmp" '
        /^# >>> brew auto-tracked/ {
            print
            while ((getline line < insert_file) > 0) print line
            close(insert_file)
            next
        }
        { print }
    ' $brewfile >$tmp.move
    mv $tmp.move $brewfile
    rm -f $tmp

    if test (count $new_taps) -gt 0
        echo ""
        echo "Brewfile updated (taps):"
        for tap in $new_taps
            echo "  + tap \"$tap\""
        end
    end
    if test (count $new_pkgs) -gt 0
        echo ""
        echo "Brewfile updated:"
        for pkg in $new_pkgs
            if test "$is_cask" = true
                if contains -- $pkg $cross_platform_casks
                    echo "  + cask \"$pkg\""
                else
                    echo "  + cask \"$pkg\" if OS.mac?"
                end
            else
                echo "  + brew \"$pkg\""
            end
        end
    end

    return $brew_status
end

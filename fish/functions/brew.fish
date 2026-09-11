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

    # an old `# >>> brew auto-tracked` block still needs one pass to be folded
    # into its section, even when there is nothing new to add
    set -l has_marker false
    if command grep -qF '# >>> brew auto-tracked' $brewfile
        set has_marker true
    end

    if test (count $new_pkgs) -eq 0; and test (count $new_taps) -eq 0; and test $has_marker = false
        return $brew_status
    end

    set -l taps_file (mktemp)
    set -l pkgs_file (mktemp)
    set -l cross_platform_casks zen
    for tap in $new_taps
        echo "tap \"$tap\"" >>$taps_file
    end
    for pkg in $new_pkgs
        if test "$is_cask" = true
            if contains -- $pkg $cross_platform_casks
                echo "cask \"$pkg\"" >>$pkgs_file
            else
                echo "cask \"$pkg\" if OS.mac?" >>$pkgs_file
            end
        else
            echo "brew \"$pkg\"" >>$pkgs_file
        end
    end
    sort -u -o $taps_file $taps_file
    sort -u -o $pkgs_file $pkgs_file

    # formulas append to the cross-platform section that precedes `# macOS-specific`;
    # casks append to the end of the `# macOS-specific` section itself
    set -l pkg_before 1
    if test "$is_cask" = true
        set pkg_before 0
    end

    set -l tmp (mktemp)
    command awk -v taps="$taps_file" -v pkgs="$pkgs_file" -v pkg_anchor='^# macOS-specific' -v pkg_before=$pkg_before '
        # append `add` to the end of one section, dropping blank lines inside it
        function splice(anchor, add, cnt, before,    a, b, last, i, j, m, out) {
            a = 0
            for (i = 1; i <= n; i++) if (line[i] ~ anchor) { a = i; break }
            if (a == 0) {
                for (j = 1; j <= cnt; j++) line[++n] = add[j]
                return
            }
            if (before == 1) {
                b = a
                a = 0
                for (i = b - 1; i >= 1; i--) if (line[i] ~ /^# /) { a = i; break }
            } else {
                b = n + 1
                for (i = a + 1; i <= n; i++) if (line[i] ~ /^# /) { b = i; break }
            }
            last = a
            for (i = a + 1; i < b; i++) if (line[i] !~ /^[[:space:]]*$/) last = i
            m = 0
            for (i = 1; i <= n; i++) {
                if (i > a && i < b && line[i] ~ /^[[:space:]]*$/) continue
                if (i == b && b <= n) out[++m] = ""
                out[++m] = line[i]
                if (i == last) for (j = 1; j <= cnt; j++) out[++m] = add[j]
            }
            n = m
            for (i = 1; i <= n; i++) line[i] = out[i]
            delete out
        }
        BEGIN {
            ntap = 0
            while ((getline l < taps) > 0) if (l !~ /^[[:space:]]*$/) tap[++ntap] = l
            close(taps)
            npkg = 0
            while ((getline l < pkgs) > 0) if (l !~ /^[[:space:]]*$/) pkg[++npkg] = l
            close(pkgs)
        }
        { line[++n] = $0 }
        END {
            # retire the legacy marker block
            m = 0
            for (i = 1; i <= n; i++) if (line[i] !~ /^# >>> brew auto-tracked/) keep[++m] = line[i]
            n = m
            for (i = 1; i <= n; i++) line[i] = keep[i]
            delete keep

            splice("^# Cross-platform packages", tap, ntap, 1)
            splice(pkg_anchor, pkg, npkg, pkg_before + 0)

            for (i = 1; i <= n; i++) print line[i]
        }
    ' $brewfile >$tmp
    mv $tmp $brewfile
    rm -f $taps_file $pkgs_file

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

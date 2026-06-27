function uclip --description 'Copy file contents or stdin to clipboard (macOS/Linux)'
    switch (uname)
        case Darwin
            if test (count $argv) -ge 1
                pbcopy < "$argv[1]"
            else
                pbcopy
            end
        case Linux
            if type -q wl-copy
                if test (count $argv) -ge 1
                    wl-copy < "$argv[1]"
                else
                    wl-copy
                end
            else if type -q xclip
                if test (count $argv) -ge 1
                    xclip -selection clipboard < "$argv[1]"
                else
                    xclip -selection clipboard
                end
            else if type -q xsel
                if test (count $argv) -ge 1
                    xsel -b < "$argv[1]"
                else
                    xsel -b
                end
            else
                echo "No clipboard tool found (install wl-clipboard, xclip, or xsel)" >&2
                return 1
            end
        case '*'
            echo "Unsupported OS: "(uname) >&2
            return 1
    end
end

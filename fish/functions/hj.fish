function hj --description "Open herdr and attach to a session if it exists, otherwise open a new session"
    set -l session_name $argv[1]

    if test -z "$session_name"
        set session_name (basename $PWD)
    end

    herdr --session $session_name
end

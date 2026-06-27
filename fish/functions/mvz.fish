function mvz --description 'Rename current directory and stay in it'
    if test (count $argv) -ne 1
        echo "Usage: mvcd <new_name>" >&2
        return 1
    end
    mv (pwd) "../$argv[1]"
    and z "../$argv[1]"
end

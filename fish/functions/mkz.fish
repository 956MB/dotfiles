function mkz --description "Create a directory and cd (zoxide) into it"
    mkdir -p $argv[1]; and z $argv[1]
end

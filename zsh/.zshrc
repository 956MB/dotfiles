if [[ "$(uname)" == "Darwin" ]]; then
    IS_MAC=true
else
    IS_MAC=false
fi

export PATH="$PATH:$HOME/dotfiles/scripts"
export PATH=~/.npm-global/bin:$PATH
export PATH="/usr/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

if [[ "$IS_MAC" == true ]]; then
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    export PATH="/opt/homebrew/opt/kleopatra/bin:$PATH"
fi
if [[ "$IS_MAC" == false ]]; then
    export GOROOT=/usr/local/go-1.23.3
    export GOPATH=$HOME/go
    export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
fi

export CLICOLOR_FORCE=1
zsh_ls_coloring=0

setopt autopushd
setopt pushdminus
setopt pushdsilent

FUNCNEST=100

# Vars
HISTFILE=~/.zsh_history
SAVEHIST=1000 
setopt inc_append_history # To save every command before it is executed 
setopt share_history # setopt inc_append_history

git config --global push.default current

# Aliases
alias v='nvim'                            # Open neovim
alias nv='nvim'                           # Open neovim (alternative)
alias z-='z -'                            # Navigate to previous directory using zoxide
alias cd..='z ..'                         # Go up one directory using zoxide
alias z..='z ..'                          # Go up one directory using zoxide (alternative)
alias ..='z ..'                           # Go up one directory using zoxide (another alternative)
alias l='ls -t'                           # List files sorted by modification time, newest first
alias ll='ls -altrhF'                     # List all files in long format, sorted by modification time (newest last), with / for directories
alias lsa='ls -hla'                       # List all files (including hidden) with human-readable sizes
alias lsr='ls -lR'                        # List files recursively
alias lsf='ls -1 | wc -l'                 # Count number of files in current directory
alias lss='du -sh *'                      # Show sizes of files and directories in current directory
alias la='ls -A'                          # List all files except . and ..
alias ls='ls -CF'                         # List files with / for directories and * for executables
alias cls='clear'                         # Clear the terminal screen
alias oldtop="/usr/bin/top"               # Run the original top command
alias nf="neofetch"                       # Display system information using neofetch
alias of="onefetch --no-color-palette --include-hidden -E --no-title"  # Display git repository information using onefetch
alias ep="echo $PATH"                     # Print the PATH environment variable
alias resh="source ~/.zshrc"              # Reload the .zshrc configuration
if [[ "$IS_MAC" == true ]]; then
    alias vzsh='kitty @ launch --type=tab nvim --remote-silent ~/.zshrc'  # Edit .zshrc in a new Kitty tab using Neovim
    alias vlua='kitty @ launch --type=tab nvim --remote-silent ~/dotfiles/nvim'  # Edit Neovim config in a new Kitty tab
else
    alias vzsh='nvim ~/.zshrc'
    alias vlua='nvim ~/dotfiles/nvim'
fi
alias monkeytype='z ~/Dev/monkeytype-24.22.0/; pnpm dev-fe'  # Navigate to monkeytype directory and start development server
alias zfq='zoxide query -l -s | less'     # List zoxide query results in less

# Command aliases
alias ftl='find . -type f -name "*.*" -exec basename {} \; | sed "s/.*\.//" | sort -u'  # List unique file extensions in current directory

if [[ "$IS_MAC" == true ]]; then
    # Yabai/skhd aliases
    alias ystart='yabai --start-service'      # Start yabai service
    alias ystop='yabai --stop-service'        # Stop yabai service
    alias yupgrade='brew upgrade yabai'       # Upgrade yabai using Homebrew
    alias skstart='skhd --start-service'      # Start skhd service
    alias skstop='skhd --stop-service'        # Stop skhd service
fi

# Git aliases
alias ga='git add'                        # Stage changes
alias gaa='git add .'                     # Stage all changes in current directory
alias gaaa='git add -A'                   # Stage all changes
alias gc='git commit'                     # Commit changes
alias gcm='git commit -m'                 # Commit changes with a message
alias gbr='git branch -M'                 # Rename current branch
alias gcr='git clone'                     # Clone a repository
alias gd='git diff'                       # Show changes between commits, commit and working tree, etc.
alias gi='git init'                       # Initialize a new Git repository
alias gl='git log'                        # Show commit logs
alias gp='git pull'                       # Fetch from and integrate with another repository or a local branch
alias gpsh='git push'                     # Update remote refs along with associated objects
alias gss='git status'                    # Show the working tree status
alias gwho='git shortlog -s -n | head'    # Show top contributors
alias gcnt='git ls-files | wc -l'         # Count number of files in the repository
alias lg='lazygit'                        # Open Lazygit interface
# This is currently causing problems (fails when you run it anywhere that isn't a git project's root directory)
# alias vs="v `git status --porcelain | sed -ne 's/^ M //p'`"

# GitHub Copilot CLI function aliases
exp() {
    gh copilot explain "$*"
}
sug() {
    gh copilot suggest "$*"
}


# Settings
export VISUAL=nvim
export EDITOR=nvim

source ~/dotfiles/zsh/plugins/fixls.zsh

#Functions
# Loop a command and show the output in vim
loop() {
    echo ":cq to quit\n" > /tmp/log/output 
    fc -ln -1 > /tmp/log/program
    while true; do
	cat /tmp/log/program >> /tmp/log/output ;
	$(cat /tmp/log/program) |& tee -a /tmp/log/output ;
	echo '\n' >> /tmp/log/output
	vim + /tmp/log/output || break;
	rm -rf /tmp/log/output
    done;
}

# git repository greeter
last_repository=
check_directory_for_new_repository() {
    current_repository=$(git rev-parse --show-toplevel 2> /dev/null)
    if [ "$current_repository" ] && \
    [ "$current_repository" != "$last_repository" ]; then
	of; l
    fi
    last_repository=$current_repository
}
cd() {
    builtin cd "$@"
    check_directory_for_new_repository
}

# Yazi 'yy' wrapper
function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
	cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# optional, greet also when opening shell directly in repository directory
# adds time to startup
check_directory_for_new_repository

# "grepr" search function
grepr() {
    grep -inRw -E "$1" "$2" --include=\*.{c,h,cpp,hpp,py,js,ts,html} --exclude-dir={.git,__pycache__,.vscode,bin,lib,include,node_modules}
}


# For vim mappings: 
stty -ixon

autoload -U compinit

plugins=(
    docker
)

for plugin ($plugins); do
    fpath=(~/dotfiles/zsh/plugins/oh-my-zsh/plugins/$plugin $fpath)
done

compinit

source ~/dotfiles/zsh/plugins/oh-my-zsh/lib/history.zsh
source ~/dotfiles/zsh/plugins/oh-my-zsh/lib/key-bindings.zsh
source ~/dotfiles/zsh/plugins/oh-my-zsh/lib/completion.zsh
source ~/dotfiles/zsh/plugins/vi-mode.plugin.zsh
source ~/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/dotfiles/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh
source ~/dotfiles/zsh/plugins/ls/ls.plugin.zsh
source ~/dotfiles/zsh/keybindings.sh

# Fix for arrow-key searching
# start typing + [Up-Arrow] - fuzzy find history forward
if [[ "${terminfo[kcuu1]}" != "" ]]; then
    autoload -U up-line-or-beginning-search
    zle -N up-line-or-beginning-search
    bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# start typing + [Down-Arrow] - fuzzy find history backward
if [[ "${terminfo[kcud1]}" != "" ]]; then
    autoload -U down-line-or-beginning-search
    zle -N down-line-or-beginning-search
    bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

source ~/dotfiles/zsh/prompt.sh
source ~/dotfiles/zsh/.env.gpa

if [[ "$IS_MAC" == true ]]; then
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('$HOME/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
	eval "$__conda_setup"
    else
	if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
	    . "$HOME/miniforge3/etc/profile.d/conda.sh"
	else
	    export PATH="$HOME/miniforge3/bin:$PATH"
	fi
    fi
    unset __conda_setup
fi

#export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.local/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [[ "$IS_MAC" == true ]]; then
    # pnpm
    export PNPM_HOME="$HOME/Library/pnpm"
    case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
    # pnpm end
else
    # WSL pnpm setup
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:$PATH"
fi

export LAZYVIM_CONFIG_PATH="$HOME/dotfiles/nvim"

eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

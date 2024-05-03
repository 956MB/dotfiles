export PATH=~/.npm-global/bin:$PATH
export PATH="/usr/bin:$PATH"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$PATH:$HOME/dotfiles/scripts"

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
    alias v='nvim' nv='nvim'
    alias cd..='cd ..'
    alias l='ls -t'
    alias ll='ls -altrF'
    alias lsa='ls -hla'
    alias lsr='ls -lR'
    alias lsf='ls -1 | wc -l'
    alias lss='du -sh *'
    alias la='ls -A'
    alias ls='ls -CF'
    alias cls='clear'
    alias oldtop="/usr/bin/top"
    alias nf="neofetch"
    alias of="onefetch --no-color-palette --include-hidden -E --no-title"
    alias ep="echo $PATH"
    alias resh="source ~/.zshrc"
    alias vzsh='kitty @ launch --type=tab nvim --remote-silent ~/.zshrc'
    alias vlua='kitty @ launch --type=tab nvim --remote-silent ~/dotfiles/nvim'

# Yabai/skhd aliases
    alias ystart='yabai --start-service'
    alias ystop='yabai --stop-service'
    alias yupgrade='brew upgrade yabai'
    alias skstart='skhd --start-service'
    alias skstop='skhd --stop-service'

# Git aliases
    alias ga='git add'
    alias gaa='git add .'
    alias gaaa='git add -A'
    alias gc='git commit'
    alias gcm='git commit -m'
    alias gcr='git clone'
    alias gd='git diff'
    alias gi='git init'
    alias gl='git log'
    alias gp='git pull'
    alias gpsh='git push'
    alias gss='git status'
    alias gcnt='git ls-files | wc -l'
    alias lg='lazygit'

# This is currently causing problems (fails when you run it anywhere that isn't a git project's root directory)
# alias vs="v `git status --porcelain | sed -ne 's/^ M //p'`"

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
# <<< conda initialize <<<

#export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.local/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="/opt/homebrew/opt/kleopatra/bin:$PATH"
export LAZYVIM_CONFIG_PATH="$HOME/dotfiles/nvim"

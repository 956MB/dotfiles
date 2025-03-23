# Load environment detection and core settings
source ~/.config/fish/conf.d/env.fish

# Add Homebrew to PATH (add this before other path configurations)
if test "$IS_MAC" = true
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

# Fix fish Ctrl+C
bind \cC 'echo; commandline ""; commandline -f repaint'

# Load environment detection and core settings
source ~/.config/fish/conf.d/env.fish

# Path configurations
fish_add_path "$HOME/dotfiles/scripts"
fish_add_path ~/.npm-global/bin
fish_add_path /usr/bin
fish_add_path "$HOME/go/bin"
fish_add_path "$HOME/Library/Python/3.9/bin"

if test "$IS_MAC" = true
    fish_add_path /usr/local/opt/coreutils/libexec/gnubin
    fish_add_path /opt/homebrew/opt/kleopatra/bin
end

# Load all aliases
source ~/.config/fish/conf.d/aliases.fish

# Git default push behavior
git config --global push.default current

# Initialize zoxide (modern alternative to z)
zoxide init fish | source

# NVM setup
set -gx NVM_DIR "$HOME/.nvm"
# Load nvm if it exists
if test -f "$NVM_DIR/nvm.sh"
    bass source "$NVM_DIR/nvm.sh"
    bass source "$NVM_DIR/bash_completion"
end

# PNPM setup based on system
if test "$IS_MAC" = true
    set -gx PNPM_HOME "$HOME/Library/pnpm"
else
    set -gx PNPM_HOME "$HOME/.local/share/pnpm"
end
fish_add_path "$PNPM_HOME"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /Users/bays/miniforge3/bin/conda "shell.fish" hook $argv | source
# <<< conda initialize <<<

# Run zellij for new tabs
# if status is-interactive && not set -q ZELLIJ
#     exec zellij
# end

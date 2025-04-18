# Load environment detection and core settings
source ~/.config/fish/conf.d/env.fish

# Add Homebrew to PATH (add this before other path configurations)
if test "$IS_MAC" = true
    eval "$(/opt/homebrew/bin/brew shellenv)"
    set zigup_bin (brew --prefix zigup)/bin
    fish_add_path $zigup_bin
end

# Fix fish Ctrl+C
bind \cC 'echo; commandline ""; commandline -f repaint'

# Path configurations
fish_add_path ~/.npm-global/bin
fish_add_path /usr/bin
fish_add_path "$HOME/go/bin"
fish_add_path "$HOME/Library/Python/3.9/bin"
fish_add_path "$HOME/.zvm/bin"
fish_add_path "$HOME/.cargo/bin"
# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

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
fish_add_path "$HOME/dotfiles/scripts"
fish_add_path "$HOME/dotfiles/scripts/zig/zig-out/bin"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# eval /Users/bays/miniforge3/bin/conda "shell.fish" hook $argv | source
# <<< conda initialize <<<

starship init fish | source

# ZVM
set -gx ZVM_INSTALL "$HOME/.zvm/self"
set -gx PATH $PATH "$HOME/.zvm/bin"
set -gx PATH $PATH "$ZVM_INSTALL/"

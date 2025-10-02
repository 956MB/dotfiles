# Load environment detection and core settings
source ~/.config/fish/conf.d/env.fish

# Add Homebrew to PATH (add this before other path configurations)
if test "$IS_MAC" = true
    eval "$(/opt/homebrew/bin/brew shellenv)"
    if command -q brew
        set zigup_bin (brew --prefix zigup)/bin
        fish_add_path $zigup_bin
    end
else
    # Linux Homebrew path
    if test -d /home/linuxbrew/.linuxbrew
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        set zigup_bin (brew --prefix zigup)/bin
        fish_add_path $zigup_bin
    end
end

# Fix fish Ctrl+C
bind \cC 'echo; commandline ""; commandline -f repaint'

# Path configurations
test -d ~/.npm-global/bin && fish_add_path ~/.npm-global/bin
test -d /usr/bin && fish_add_path /usr/bin
test -d "$HOME/go/bin" && fish_add_path "$HOME/go/bin"
test -d "$HOME/.zvm/bin" && fish_add_path "$HOME/.zvm/bin"
test -d "$HOME/.cargo/bin" && fish_add_path "$HOME/.cargo/bin"

# Python paths (different on macOS vs Linux)
if test "$IS_MAC" = true
    test -d "$HOME/Library/Python/3.9/bin" && fish_add_path "$HOME/Library/Python/3.9/bin"
else
    test -d "$HOME/.local/bin" && fish_add_path "$HOME/.local/bin"
end

# bun
if command -q brew
    set llvm_bin (brew --prefix llvm@19)/bin
    fish_add_path $llvm_bin
end
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

if test "$IS_MAC" = true
    test -d /usr/local/opt/coreutils/libexec/gnubin && fish_add_path /usr/local/opt/coreutils/libexec/gnubin
    test -d /opt/homebrew/opt/kleopatra/bin && fish_add_path /opt/homebrew/opt/kleopatra/bin
end

# Load all aliases
if test -f ~/.config/fish/conf.d/aliases.fish
    source ~/.config/fish/conf.d/aliases.fish
end

# Git default push behavior
git config --global push.default current

# Initialize zoxide (modern alternative to z)
if command -q zoxide
    zoxide init fish | source
end

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
test -d "$PNPM_HOME" && fish_add_path "$PNPM_HOME"
test -d "$HOME/dotfiles/scripts" && fish_add_path "$HOME/dotfiles/scripts"
test -d "$HOME/dotfiles/scripts/zig/zig-out/bin" && fish_add_path "$HOME/dotfiles/scripts/zig/zig-out/bin"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# eval /Users/bays/miniforge3/bin/conda "shell.fish" hook $argv | source
# <<< conda initialize <<<

if command -q starship
    starship init fish | source
end

if type -q nvim
    set -x EDITOR (which nvim)
    set -x VISUAL (which nvim)
end
set -gx PATH $PATH "$HOME/linuxbrew/.linuxbrew/bin"
set -gx ZVM_INSTALL "$HOME/.zvm/self"
set -gx PATH $PATH "$HOME/.zvm/bin"
set -gx PATH $PATH "$ZVM_INSTALL/"
set -gx PATH $PATH "$HOME/.lmstudio/bin"

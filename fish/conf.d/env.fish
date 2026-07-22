# System detection
set -gx IS_MAC (test (uname) = "Darwin" && echo true || echo false)

# Environment variables
set -gx CLICOLOR_FORCE 1
set -gx VISUAL nvim
set -gx EDITOR nvim
set -gx LAZYVIM_CONFIG_PATH "$HOME/dotfiles/nvim"
set -gx OPENCODE_DISABLE_CLAUDE_CODE_SKILLS 1

# Go configuration for non-macOS
if test "$IS_MAC" = false
    set -gx GOROOT /usr/local/go-1.23.3
    set -gx GOPATH $HOME/go
end

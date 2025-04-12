# General aliases
alias v='nvim'                                               # Open neovim
alias nv='nvim'                                              # Open neovim (alternative)
alias z-='z -'                                               # Navigate to previous directory using zoxide
alias cd..='z ..'                                            # Go up one directory using zoxide
alias z..='z ..'                                             # Go up one directory using zoxide (alternative)
alias ..='z ..'                                              # Go up one directory using zoxide
alias ...='z ../..'                                          # Go up two directories using zoxide
alias ....='z ../../..'                                      # Go up three directories using zoxide
alias zfreq='zoxide query -l'                                # List most frequently used directories
alias yy='yazi'                                              # Open yazi
alias fct='find . -maxdepth 1 -type d ! -name ".*" | wc -l'  # Count number of directories in the current directory (excluding hidden ones)

# Zellij aliases
alias zsr='zellij ac rename-session'  # Rename zellij session <name>
alias zsa='zellij a'                  # Attach to zellij session <name>
alias zsl='zellij ls'                 # List zellij sessions
alias zsk='zellij k'                  # Kill zellij session <name>
alias zsd='zellij d'                  # Delete zellij session <name>

if type -q eza
    alias l='eza --group-directories-first'                    # List with icons, directories first
    alias ls='eza --group-directories-first'                   # List with icons, directories first
    alias ll='eza -la --group-directories-first'               # Long format with icons
    alias la='eza -la --group-directories-first'               # List all (including hidden) with icons
    alias lt='eza --tree --icons'                              # Tree view with icons
    alias l.='eza -a | grep -E "^\."'                          # Show only hidden files
    alias lsa='eza -la --group-directories-first'              # List all with icons (including hidden)
    alias lsr='eza -R --icons'                                 # List recursively
    alias lsf='eza -1 | wc -l'                                 # Count number of files
    alias lss='eza -la --group-directories-first --sort=size'  # Sort by size
else
    alias l='ls -t -G'            # List files sorted by modification time, newest first
    alias ll='ls -altrhF -G'      # List all files in long format, sorted by modification time (newest last), with / for directories
    alias lsa='ls -hla -G'        # List all files (including hidden) with human-readable sizes
    alias lsr='ls -lR -G'         # List files recursively
    alias lsf='ls -G -1 | wc -l'  # Count number of files in current directory
    alias lss='du -sh *'          # Show sizes of files and directories in current directory
    alias la='ls -A -G'           # List all files except . and ..
    alias ls='ls -CF -G'          # List files with / for directories and * for executables
end

alias cls='clear'                                                      # Clear the terminal screen
alias oldtop='usr/bin/top'                                            # Run the original top command
alias ff='fastfetch --logo dotfiles/ascii_logo.txt'                    # Display system information using neofetch and my ascii_logo
alias nf='neofetch'                                                    # Display system information using neofetch
alias of='onefetch --no-color-palette --include-hidden -E --no-title'  # Display git repository information using onefetch
alias ep='echo \$PATH'                                                 # Print the PATH environment variable
alias resh='source ~/.config/fish/config.fish'                         # Reload the fish configuration

# Git aliases
alias ga='git add'                      # Stage changes
alias gaa='git add .'                   # Stage all changes in current directory
alias gaaa='git add -A'                 # Stage all changes
alias gc='git commit'                   # Commit changes
alias gcm='git commit -m'               # Commit changes with a message
alias gbr='git branch -M'               # Rename current branch
alias gd='git diff'                     # Show changes between commits, commit and working tree, etc.
alias gds='git diff --stat'             # Show diff stats (files changed, insertions, deletions)
alias gi='git init'                     # Initialize a new Git repository
alias gl='git log'                      # Show commit logs
alias gp='git pull'                     # Fetch from and integrate with another repository or a local branch
alias gpsh='git push'                   # Update remote refs along with associated objects
alias gss='git status'                  # Show the working tree status
alias gwho='git shortlog -s -n | head'  # Show top contributors
alias gcnt='git ls-files | wc -l'       # Count number of files in the repository
alias lg='lazygit'                      # Open Lazygit interface
alias grl='gh repo ls 956MB'            # List my repos on GitHub
alias grlf='gh repo ls 956MB --fork'    # List my forked repos on GitHub

# System-specific aliases
if test "$IS_MAC" = true
    alias vzsh='kitty @ launch --type=tab nvim --remote-silent ~/.config/fish/config.fish'  # Edit fish config in a new Kitty tab using Neovim
    alias vlua='kitty @ launch --type=tab nvim --remote-silent ~/dotfiles/nvim'             # Edit Neovim config in a new Kitty tab

    # Yabai/skhd aliases
    alias ystart='yabai --start-service'  # Start yabai service
    alias ystop='yabai --stop-service'    # Stop yabai service
    alias yupgrade='brew upgrade yabai'   # Upgrade yabai using Homebrew
    alias skstart='skhd --start-service'  # Start skhd service
    alias skstop='skhd --stop-service'    # Stop skhd service
else
    alias vzsh='nvim ~/.config/fish/config.fish'
    alias vlua='nvim ~/dotfiles/nvim'
end

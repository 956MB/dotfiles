# e.g.: alias ll='ls -l' # List files in long format
#       ^     ^   ^      ^
#       |     |   |      |-- Description (optional)
#       |     |   |--------- Content (command)
#       |     |------------- Key (alias name)
#       |------------------- Alias definition

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
alias func='functions'                                       # List all functions

# Tailscale aliases (watch out for close "tsc" command (typescript compiler))
alias ts='tailscale'                                         # Tailscale command
alias tsh='tailscale --help'                                 # Tailscale help
alias tsup='tailscale up'                                    # Start Tailscale
alias tsdown='tailscale down'                                # Stop Tailscale
alias tss='tailscale status'                                 # Show Tailscale status
alias tsip='tailscale ip'                                    # Show Tailscale IPv4 address
alias tssh='tailscale ssh'                                   # SSH into a Tailscale machine
# TODO: Add more from the `tailscale --help`

# Zellij aliases
alias zsr='zellij ac rename-session'  # Rename zellij session <name>
alias zsa='zellij a'                  # Attach to zellij session <name>
alias zsl='zellij ls'                 # List zellij sessions
alias zsk='zellij k'                  # Kill zellij session <name>
alias zsd='zellij d'                  # Delete zellij session <name>

# zigup aliases
alias zup='zigup'                 # <version>: Fetch compiler and set default
alias zupf='zigup fetch'          # <version>: Fetch Zig compiler
alias zupls='zigup list'          # List installed Zig versions
alias zupdef='zigup default'      # Set global Zig version
alias zupcl='zigup cleanup'       # Clean compilers that aren't default/master/keep
alias zupkp='zigup keep'          # <version>: Mark compiler as keep
alias zupr='zigup run'            # <version> <args>: Run specific compiler

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
alias oldtop='usr/bin/top'                                             # Run the original top command
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

# jj aliases
alias jji='jj git init --colocate'       # Initialize a new jj repository
alias jjn='jj new'                       # Create a new working copy
alias jjcr='jj git clone'                # Clone a repository
alias jjf='jj git fetch'                 # Fetch changes from the remote
alias jjim='jj git import'               # Import remote refs into jj
alias jjex='jj git export'               # Export refs to a remote (use normal git push afterwards)
alias jjbl='jj bookmark list --all'      # List all bookmarks
alias jjbt='jj bookmark track'           # Track a branch
alias jjbc='jj bookmark create'          # Create a new bookmark
alias jjl='jj log'                       # Log our commits (excludes untracked remote branches)
alias jjlop='jj op log'                  # Log operations
alias jjla='jj log --all'                # Log all commits
alias jjdi='jj diff -r'                  # Show differences between commits
alias jjs='jj status'                    # Show the status of the repository
alias jjsp='jj split'                    # Select files to be commited and create new working copy
alias jjd='jj describe'                  # Describe any commit
alias jjdm='jj describe -m'              # Describe the current commit with message
alias jjrb='jj rebase -d'                # Rebase current commit onto a different branch
alias jjre='jj reset'                    # Reset the current working copy to a specific commit
alias jjco='jj checkout'                 # Switch working copy to a branch/commit
alias jjca='jj abandon'                  # Abandon current commit / working copy
alias jjup='jj git fetch; jj git import' # Shortcut for "pull" behavior
alias jjpush='jj git export; git push'   # Shortcut for "push"
alias jjpop='jj undo'                    # Alt name for "pop last operation"
alias jjw='jj workspace list'            # List all working copies
alias jjwf='jj workspace forget'         # Forget the current workspace (or given name)
alias jjwa='jj workspace add'            # Add a new workspace
alias lj='lazyjj'                        # Open Lazyjj interface

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

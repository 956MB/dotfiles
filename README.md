<p align="center">
    <a href="https://github.com/ghostty-org/ghostty">
        <img src="./.github/ghostty.png" alt="ghostty" width="210">
    </a>
</p>

![Screenshot](./.github/Screenshot_2024-12-08_at_6.27.59_AM.png)

### `install.sh` script (for me)

I made this script for myself to make it easier starting on different systems, so the stuff inside is focused on my personal preferences and keeping my configs exactly the same. **Run at your own risk.**

```ruby
curl -fsSL https://raw.githubusercontent.com/956MB/dotfiles/main/install.sh | bash
```

The script will:

-   Backup existing configurations (e.g. `~/.config-backup-20250727_064950`)
-   Install the main packages for the shell (`Homebrew`, `eza`, `starship`, `zoxide`, `zellij`, `Fish`)
-   Clone this repository and create symlinks
-   Install packages from the [Brewfile](./Brewfile) (optional)
-   Set `Fish` as the default shell

```bash
./install.sh
./install.sh {-p, --packages-only}  # Packages only (no symlinks/shell changes)
./install.sh {-r, --revert}         # Revert to previous configuration
```

---

### Aliases

[fish/aliases.fish](./fish/conf.d/aliases.fish)

##### General

```bash
alias v='nvim'                                                         # Open neovim
alias nv='nvim'                                                        # Open neovim (alternative)
alias z-='z -'                                                         # Navigate to previous directory using zoxide
alias cd..='z ..'                                                      # Go up one directory using zoxide
alias z..='z ..'                                                       # Go up one directory using zoxide (alternative)
alias ..='z ..'                                                        # Go up one directory using zoxide
alias ...='z ../..'                                                    # Go up two directories using zoxide
alias ....='z ../../..'                                                # Go up three directories using zoxide
alias zfreq='zoxide query -l'                                          # List most frequently used directories
alias yy='yazi'                                                        # Open yazi
alias fct='find . -maxdepth 1 -type d ! -name ".*" | wc -l'            # Count number of directories in the current directory (excluding hidden ones)
alias func='functions'                                                 # List all functions
alias cat='bat'                                                        # Use bat instead of cat
alias oldcat='cat'                                                     # Use original cat
alias l='eza --group-directories-first'                                # List with icons, directories first
alias ls='eza --group-directories-first'                               # List with icons, directories first
alias ll='eza -l --group-directories-first'                            # Long format with icons
alias la='eza -la --group-directories-first'                           # List all (including hidden) with icons
alias lt='eza --tree --icons'                                          # Tree view with icons
alias l.='eza -a | grep -E "^\."'                                      # Show only hidden files
alias lsa='eza -la --group-directories-first'                          # List all with icons (including hidden)
alias lsr='eza -R --icons'                                             # List recursively
alias lsf='eza -1 | wc -l'                                             # Count number of files
alias lss='eza -la --group-directories-first --sort=size'              # Sort by size
alias cls='clear'                                                      # Clear the terminal screen
alias oldtop="/usr/bin/top"                                            # Run the original top command
alias nf="neofetch"                                                    # Display system information using neofetch
alias of='onefetch --no-color-palette --include-hidden -E --no-title --ascii-input "$(cat ~/dotfiles/logos/logo.txt)"'  # Display git repository information using onefetch with logo
alias ep="echo $PATH"                                                  # Print the PATH environment variable
alias resh="source ~/.config/fish/config.fish"                         # Reload the fish configuration
alias nvs="nvim ~/.scratch/$(date +%Y-%m-%d-%H%M%S).txt"               # Open a timestamped scratch file in neovim
```

##### Zellij

[zellij/config.kdl](./zellij/config.kdl)

```bash
alias zsr='zellij ac rename-session'  # Rename zellij session <name>
alias zsa='zellij a'                  # Attach to zellij session <name>
alias zsl='zellij ls'                 # List zellij sessions
alias zsk='zellij k'                  # Kill zellij session <name>
alias zsd='zellij d'                  # Delete zellij session <name>
```

##### Tailscale

```bash
alias ts='tailscale'                                  # Tailscale command
alias tsh='tailscale --help'                          # Tailscale help
alias tsv='tailscale version'                         # Tailscale version
alias tsup='tailscale up'                             # Start Tailscale
alias tsdown='tailscale down'                         # Stop Tailscale
alias tss='tailscale status'                          # Show Tailscale status
alias tsip='tailscale ip'                             # Show Tailscale IPv4 address
alias tssh='tailscale ssh'                            # SSH into a Tailscale machine
alias tsdc='ps aux | grep tailscaled | grep -v grep'  # Check if tailscaled daemon is running
```

##### Commands

```bash
alias ftl='find . -type f -name "*.*" -exec basename {} \; | sed "s/.*\.//" | sort -u'  # List unique file extensions in current directory
```

##### Version control (`git`)

```bash
alias ga='git add'                      # Stage changes
alias gaa='git add .'                   # Stage all changes in current directory
alias gaaa='git add -A'                 # Stage all changes
alias gc='git commit'                   # Commit changes
alias gcm='git commit -m'               # Commit changes with a message
alias gbr='git branch -M'               # Rename current branch
alias gcr='git clone'                   # Clone a repository
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

# GitHub Copilot CLI function aliases
exp() {
    gh copilot explain "$*"
}
sug() {
    gh copilot suggest "$*"
}
```

##### Yabai/skhd

[yabairc](./yabai/.yabairc) · [skhdrc](/yabai/..skhdrc)

```bash
alias ystart='yabai --start-service'      # Start yabai service
alias ystop='yabai --stop-service'        # Stop yabai service
alias yupgrade='brew upgrade yabai'       # Upgrade yabai using Homebrew
alias skstart='skhd --start-service'      # Start skhd service
alias skstop='skhd --stop-service'        # Stop skhd service
```

---

### Scripts & Fish functions

[aliaz](./scripts/zig/aliaz)

<sup>A better `alias` command, and my first thing written in Zig for fun. Uses color and description comments in `fish/conf.d/aliases.fish`.</sup>

[gcr.fish](./fish/functions/gcr.fish) & [gcrz.fish](./fish/functions/gcrz.fish)

<sup>Clones a repo from https/ssh (and `z` into it), and as backup uses github cli</sup>

```ruby
{gcr, gcrz} https://github.com/Next-Flip/Momentum-Firmware.git
```

[zj.fish](./fish/functions/zj.fish)

<sup>Opens a zellij session if it exists and creates it if not</sup>

```ruby
zj # -> zellij attach <cwd> -c
```

[zsde.fish](./fish/functions/zsde.fish)

<sup>Delete all exited zellij sessions except the ones specified</sup>

```ruby
zsde dotfiles|Momentum-Firmware.wiki # -> zellij ls -n | grep EXITED | grep -v "dotfiles\|Momentum-Firmware.wiki" | awk '{print $1}' | xargs -I {} zellij d {}
```

---

```python
# onefetch --no-color-palette --include-hidden -E --no-title --ascii-input "$(cat ./logos/logo-50b.txt)"
⠀⢠⣤⣤⣤⣤⣠⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⡀   HEAD: 62f8c7c (main, github/main)
⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⢿⣿⣿⡿   Pending: 5+- 2+
⠀⠙⠻⣿⣿⣧⡉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡿⣻⠁⠀   Created: 2 years ago
⠀⠀⠀⠉⢻⣿⣿⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⡟⠀⠀⠀   Languages:
⠀⠀⠀⠀⠀⠈⠛⢿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⣤⣿⣿⠋⠀⠀⠀⠀              ● Lua (83.8 %) ● Fish (6.6 %)
⠀⠀⠀⠀⠀⠀⠀⠀⠉⠋⠁⠀⠀⠀⠀⠀⠀⣰⣾⡿⠏⠀⠀⠀⠀⠀⠀              ● Shell (3.6 %) ● Python (1.7 %)
⠀⣠⣤⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⡿⠟⠀⠀⠀⠀⠀⠀⠀⠀              ● BASH (1.4 %) ● Zig (1.3 %)
⠀⣿⣿⣿⣿⣶⣤⡀⠀⠀⠀⠀⠀⢀⢔⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀              ● Other (1.7 %)
⠀⢹⣿⣿⠛⢿⣻⣿⣶⣤⡀⠀⡔⣡⡞⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   Authors: 54% Alexander Bays <bays@956mb.com> 73
⠀⠸⣿⣿⠂⠀⠉⠘⠿⣿⣿⢿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀            44% 956MB <bays@956mb.com> 59
⠀⢠⣿⣿⠀⠀⠀⠀⣀⣾⣽⠻⢿⣿⣧⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀             1% Alexander Bays <bays@MacBookPro.attlocal.net> 2
⠀⢸⣿⣿⠀⢀⣤⣾⣿⠟⠁⠀⠀⠈⠹⢿⣏⣷⣦⣄⣀⠀⠀⠀⠀⠀⠀   Last change: 2 weeks ago
⠀⠈⣿⣿⣴⣼⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣿⣧⣆⡠⣀⠀⠀   Commits: 134
⠀⠀⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⣿⣿⣷⣷⣆   Churn (2): …/functions/zellij_tabs.fish 1
⠀⠀⠙⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠛⠋              Brewfile 1
                                         …/plugins/editor.lua 1
                              Lines of code: 16745
                              Size: 16.42 MiB (130 files)
                              License: MIT
```

[MIT license](./LICENSE)

<p align="center">
    <a href="https://github.com/ghostty-org/ghostty">
        <img src="./.github/ghostty.png" alt="ghostty" width="210">
    </a>
</p>

![Screenshot](./.github/Screenshot_2024-12-08_at_6.27.59_AM.png)

### Repository layout

```
dotfiles/
├── dot                    # Setup + management script (init, update, doctor, packages, ...)
├── nvim/                  # Neovim: Lazy.nvim config, 200+ lua files, 11 custom plugins
├── fish/                  # Fish shell: config.fish, conf.d/ (aliases, env), functions/
├── scripts/               # Standalone tools: aliaz (Zig), Python + shell helpers
├── themes/                # Theme registry and notes (kanso, matteblack, greyscale)
├── ghostty/  zellij/  yazi/  lazygit/    # Terminal tool configs
├── bat/  btop/  delta/  starship/        # CLI appearance configs
├── zed/  opencode/  pi/                  # Editor and AI agent tool configs
├── herdr/  hunk/  jj/                    # Multiplexer, diff-review pager, jj UI
├── ssh/  utils/  misc/  backup/  moshi/  # Keys, helpers, one-off files
├── Brewfile                              # Homebrew packages (brew bundle input)
└── .gitconfig                            # Git config: SSH signing, aliases, rewrites
```

Everything under a config dir gets symlinked into `~/.config/<dir>` by [dot](#dot-script-for-me) — edit files here, never in the live `~/.config` paths.

---

### `dot` script (for me)

Setup and management script for this dotfiles repo: installs everything on a fresh machine and keeps the configs linked and healthy on machines already running them. **Run at your own risk.**

```bash
curl -fsSL https://raw.githubusercontent.com/956MB/dotfiles/main/dot | bash
```

A full run (`dot init`) will:

-   **Backup** existing configs (bat, btop, delta, fish, ghostty, herdr, nvim, yazi, zed, zellij, starship.toml, .gitconfig) to `~/.config-backup-*`
-   **Install** Homebrew, Fish shell, and Fish tooling (eza, starship, zoxide, zellij, herdr)
-   **Clone** the repo and create symlinks for the same set of configs
-   **Install** packages from the [Brewfile](./Brewfile) (optional, with GUI/non-GUI prompts)
-   **Set** Fish as the default shell
-   **Generate** an SSH key for GitHub remotes and commit signing (optional, skippable)

It runs on macOS (Intel + Apple Silicon) and Linux, with an interactive menu on first launch.

```bash
dot                            # Interactive menu (same as dot init)
dot init [--skip-ssh]          # Full setup: backup, brew, clone, symlinks, packages, fish shell
dot symlinks                   # Link/relink configs only
dot packages                   # Install Brewfile packages only
dot update                     # Pull latest dotfiles, re-link, brew update/upgrade + bundle sync
dot check-packages             # Report installed vs missing Brewfile packages
dot doctor                     # Health check: tools, config symlinks, shell
dot gen-ssh-key [email]        # Generate an ed25519 key, copies the pub key to clipboard
dot completions [dir]          # Generate Fish completions (default: fish/completions in the repo)
dot link                       # Install dot on PATH (symlink into ~/.local/bin or /usr/local/bin)
dot unlink                     # Remove the dot symlink from PATH
dot revert                     # Restore from the most recent ~/.config-backup-*
dot help                       # All commands + legacy flags (-p, -s, -r still work)
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
alias top='btop'                                                       # Use btop instead of top
alias oldtop="/usr/bin/top"                                            # Run the original top command
alias nf="neofetch"                                                    # Display system information using neofetch
alias of='onefetch --no-color-palette --include-hidden -E --no-title --ascii-input "$(cat ~/dotfiles/.github/logos/logo.txt)"'  # Display git repository information using onefetch with logo
alias ep="echo $PATH"                                                  # Print the PATH environment variable
alias resh="source ~/.config/fish/config.fish"                         # Reload the fish configuration
alias nvs="nvim ~/.scratch/$(date +%Y-%m-%d-%H%M%S).txt"               # Open a timestamped scratch file in neovim
alias mkd="mkdir"                                                      # Create a new directory
alias ld='lazydocker'                                                  # Open Lazydocker interface
alias ff='fastfetch --logo ~/dotfiles/logo.txt'                        # Display system info with logo
alias cl='linecounts'                                                  # List files sorted by line count
alias vzsh='nvim ~/.config/fish/config.fish'
alias vlua='nvim ~/dotfiles/nvim'

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
alias ts='tailscale'                                                        # Tailscale command
alias tsh='tailscale --help'                                                # Tailscale help
alias tsv='tailscale version'                                               # Tailscale version
alias tsup='tailscale up'                                                   # Start Tailscale
alias tsdown='tailscale down'                                               # Stop Tailscale
alias tss='tailscale status'                                                # Show Tailscale status
alias tsip='tailscale ip'                                                   # Show Tailscale IPv4 address
alias tssh='tailscale ssh'                                                  # SSH into a Tailscale machine
alias tsdc='ps aux | grep tailscaled | grep -v grep'                        # Check if tailscaled daemon is running
alias tsre='sudo pkill tailscaled; sleep 1; brew services start tailscale'  # Restart tailscaled daemon (after brew upgrade)
```

##### Vicinae (Raycast-like launcher for Linux)

```bash
alias vicstart='systemctl --user start vicinae.service'
alias vicstop='systemctl --user stop vicinae.service'
alias vicrestart='systemctl --user restart vicinae.service'
alias vicstatus='systemctl --user status vicinae.service'
alias vicenable='systemctl --user enable --now vicinae.service'
alias vicdisable='systemctl --user disable vicinae.service'
```

##### zigup (Zig version manager)

```bash
alias zup='zigup'                 # <version>: Fetch compiler and set default
alias zupf='zigup fetch'          # <version>: Fetch Zig compiler
alias zuph='zigup --help'         # Zigup help
alias zupls='zigup list'          # List installed Zig versions
alias zupdef='zigup default'      # Set global Zig version
alias zupcl='zigup cleanup'       # Clean compilers that aren't default/master/keep
alias zupkp='zigup keep'          # <version>: Mark compiler as keep
alias zupr='zigup run'            # <version> <args>: Run specific compiler
```

##### Herdr (terminal multiplexer / workspace manager)

[herdr/config.toml](./herdr/config.toml)

```bash
alias hreload='herdr server reload-config'  # Reload config without restart
alias hsa='herdr session attach'            # Attach to session <name>
alias hsl='herdr session list'              # List sessions
alias hsk='herdr session stop'              # Stop session <name>
alias hsd='herdr session delete'            # Delete session <name>
alias hsr='herdr workspace rename'          # Rename workspace <id> <name>
alias hwl='herdr workspace list'            # List workspaces
alias hwc='herdr workspace create'          # Create a new workspace
alias hst='herdr status'                    # Show herdr status
```

##### Commands

```bash
alias ftl='find . -type f -name "*.*" -exec basename {} \; | sed "s/.*\.//" | sort -u'  # List unique file extensions in current directory
```

##### Version control (`jj` + `git`)

<sup>Day-to-day version control runs through [jjui](./jj/jjui/) — previously [Lazygit](https://github.com/jesseduffield/lazygit) — rather than the terminal aliases below. The aliases cover quick one-off cases; git still works everywhere since the repo is jj + git colocated.</sup>

<details>
<summary>jj aliases</summary>

[jj aliases](./fish/conf.d/aliases.fish)

```bash
alias jc='jj commit'                    # Move working-copy changes into a new commit, start a fresh one
alias jcm='jj commit -m'                # Commit working-copy changes with a message
alias jdesc='jj describe'               # Edit the description of a change
alias je='jj edit'                      # Edit the contents of a change
alias jn='jj new'                       # Start a new change on top of the working copy
alias jbr='jj bookmark set'             # Create or update a bookmark (jj's branch)
alias jd='jj diff'                      # Show changes in a revision
alias jds='jj diff --stat'              # Show diff stats (files changed, insertions, deletions)
alias ji='jj git init --colocate'       # Initialize a colocated jj + git repository
alias jl='jj log'                       # Show the change graph
alias jpl='jj git fetch'                # Fetch from remotes and rebase local changes
alias jpush='jj git push'               # Push bookmarked commits to the remote
alias jpushc='jj git push --change @'   # Push the working-copy change (creates a remote bookmark)
alias jss='jj st'                       # Show the working-copy status
alias jwho="jj log -r 'latest(::, 20)' --no-graph -T 'author.name() ++ \"\\n\"' | sort | uniq -c | sort -rn | head"  # Show top contributors
alias jcnt='jj file list | wc -l'       # Count number of files tracked in the repository
alias jui='jjui'                        # Open jjui interface (go-to VCS TUI)
```

</details>

<details>
<summary>git aliases</summary>

[git aliases](./fish/conf.d/aliases.fish)

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
alias lg='lazygit'                      # Open Lazygit interface (previous VCS TUI)
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

</details>

---

### Scripts & Fish functions

[aliaz](./scripts/zig/aliaz)

<sup>A better `alias` command, and my first thing written in Zig for fun. Uses color and description comments in `fish/conf.d/aliases.fish`.</sup>

[brew.fish](./fish/functions/brew.fish)

<sup>`brew` wrapper that mirrors `install`/`uninstall`/`reinstall` into `Brewfile`. Parses `--cask` and known flags so the Brewfile stays in sync automatically.</sup>

[cwd.fish](./fish/functions/cwd.fish)

<sup>Prints the absolute path of a file/directory (default `.`) and copies it to the clipboard.</sup>

[fcs.fish](./fish/functions/fcs.fish)

<sup>Counts total first-level subdirectories across all top-level folders.</sup>

[gcr.fish](./fish/functions/gcr.fish) & [gcrz.fish](./fish/functions/gcrz.fish)

<sup>Clones a repo from https/ssh (and `z` into it), and as backup uses github cli</sup>

```ruby
{gcr, gcrz} https://github.com/Next-Flip/Momentum-Firmware.git
```

[hj.fish](./fish/functions/hj.fish)

<sup>Opens a herdr session, defaulting to the current directory name.</sup>

```ruby
hj # -> herdr --session <cwd>
```

[linecounts.fish](./fish/functions/linecounts.fish)

<sup>Lists all files (skipping node_modules, .git, dist, etc.) sorted by line count.</sup>

[mkz.fish](./fish/functions/mkz.fish)

<sup>Create a directory and `z` into it in one step.</sup>

[mvz.fish](./fish/functions/mvz.fish)

<sup>Renames the current directory and stays inside it.</sup>

[psd-sizes.fish](./fish/functions/psd-sizes.fish)

<sup>Finds all `.psd` files recursively and prints their sizes in MB/GB with a total.</sup>

[publish.fish](./fish/functions/publish.fish)

<sup>Initialize a git repo and publish it to GitHub as a new repo (defaults to private, pass `--public` to override).</sup>

[tailscale-update.fish](./fish/functions/tailscale-update.fish)

<sup>Updates Tailscale via Homebrew and restarts the daemon, handling root-owned tailscaled and firewall rules.</sup>

[uclip.fish](./fish/functions/uclip.fish)

<sup>Copy file contents or stdin to clipboard. Works on macOS (`pbcopy`) and Linux (`wl-copy`/`xclip`/`xsel`).</sup>

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
# onefetch --no-color-palette --include-hidden -E --no-title --ascii-input "$(cat ./.github/logos/logo-52b.txt)"
⠀⠀⣀⠀⡀⢀⡀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⡀⠀⠀   HEAD: 5a958a3 (main, github/main)
⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⡂   Pending: 2+- 3+
⠈⠻⣿⣿⣿⣿⣶⡀⠈⠈⠈⠉⠉⠉⠉⠃⠋⠉⠋⠉⠉⠉⠉⠉⣿⣿⢿⡯⡟⠀   Created: 2 years ago
⠀⠀⠈⠻⣿⣻⣽⣷⣢⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⡿⡽⠊⠀⠀   Languages:
⠀⠀⠀⠀⠈⠛⢯⣷⣿⣳⡢⡀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⠯⠋⠀⠀⠀⠀              ● Lua (83.0 %) ● Fish (8.5 %)
⠀⠀⠀⠀⠀⠀⠀⠙⢾⢵⢯⡳⣑⡀⠀⠀⠀⠀⢀⣴⣿⣿⡿⠇⠁⠀⠀⠀⠀⠀              ● Shell (3.1 %) ● Python (1.5 %)
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢵⢹⡪⡪⡢⡀⣀⣴⣿⣿⣿⠏⠁⠀⠀⠀⠀⠀⠀⠀              ● BASH (1.2 %) ● Zig (1.1 %)
⠀⢠⣾⣿⣧⣄⡀⠀⠀⠀⠀⠑⠕⡝⣼⣾⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀              ● Other (1.5 %)
⠀⢸⣿⣿⢿⡿⣿⣷⣤⣀⠀⠀⠀⣠⣿⣟⣿⣟⢇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   Authors: 50% 956MB <bays@956mb.com> 76
⠀⠀⣟⣾⣻⠟⣿⢾⣻⡿⣿⣦⣾⣻⣽⡟⣟⢮⣳⢥⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀            48% Alexander Bays <bays@956mb.com> 73
⠀⠀⣟⡾⣽⠃⠀⠙⠫⣿⣯⣿⣽⣿⣷⣧⡀⠙⣾⣯⣷⣅⡀⠀⠀⠀⠀⠀⠀⠀             1% Alexander Bays <bays@MacBookPro.attlocal.net> 2
⠀⠀⣗⣯⣳⡃⠀⢠⣾⣳⣿⢾⢿⡾⣯⣿⣿⣷⣮⣷⣷⣻⢮⣄⠀⠀⠀⠀⠀⠀   Last change: 34 seconds ago
⠀⠀⣗⢧⣳⣃⣴⣿⣯⣿⡾⠅⠁⠈⠙⠳⢿⣽⣿⣽⣿⣿⣯⣿⣵⡀⠀⠀⠀⠀   Commits: 151
⠀⠀⢸⣳⣿⣿⣿⣟⣯⠏⠁⠀⠀⠀⠀⠀⠀⠉⠚⠿⣾⣟⣿⢿⣿⣿⣦⡀⠀⠀   Churn (2): .gitignore 2
⠀⠀⠘⣿⣿⢿⣽⡟⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⢿⣿⣻⣿⣯⣆⠀              …/kanso.nvim/README.md 1
⠀⠀⠀⠙⠁⠁⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠛⠟⠁⠀              …/kanso/colors.lua 1
                                 Lines of code: 18426
                                 Size: 21.24 MiB (178 files)
                                 License: MIT
```

[MIT license](./LICENSE)

## Acknowledgements

- [Homebrew](https://brew.sh/) and [Fish](https://fishshell.com/) as the base the install script builds on
- [dmmulrow](https://github.com/dmmulroy) and his [dotfiles](https://github.com/dmmulroy/.dotfiles) — his `dot` script was better than mine
- [pi](https://github.com/badlogic/pi-mono) — for AI assistance

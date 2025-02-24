<p align="center">
    <a href="https://github.com/ghostty-org/ghostty">
        <img src="./img/ghostty.png" alt="ghostty" width="210">
    </a>
</p>

![Screenshot](./img/Screenshot_2024-12-08_at_6.27.59_AM.png)

### Aliases

##### General

[fish/aliases.fish](./fish/conf.d/aliases.fish)

```bash
alias v='nvim'                            # Open neovim
alias nv='nvim'                           # Open neovim (alternative)
alias z-='z -'                            # Navigate to previous directory using zoxide
alias cd..='z ..'                         # Go up one directory using zoxide
alias z..='z ..'                          # Go up one directory using zoxide (alternative)
alias ..='z ..'                           # Go up one directory using zoxide
alias ...='z ../..'                       # Go up two directories using zoxide
alias ....='z ../../..'                   # Go up three directories using zoxide
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
alias resh="source ~/.config/fish/config.fish"  # Reload the fish configuration
```

##### Commands

```bash
alias ftl='find . -type f -name "*.*" -exec basename {} \; | sed "s/.*\.//" | sort -u'  # List unique file extensions in current directory
```

##### Git

```bash
alias ga='git add'                        # Stage changes
alias gaa='git add .'                     # Stage all changes in current directory
alias gaaa='git add -A'                   # Stage all changes
alias gc='git commit'                     # Commit changes
alias gcm='git commit -m'                 # Commit changes with a message
alias gbr='git branch -M'                 # Rename current branch
alias gcr='git clone'                     # Clone a repository
alias gd='git diff'                       # Show changes between commits, commit and working tree, etc.
alias gds='git diff --stat'               # Show diff stats (files changed, insertions, deletions)
alias gi='git init'                       # Initialize a new Git repository
alias gl='git log'                        # Show commit logs
alias gp='git pull'                       # Fetch from and integrate with another repository or a local branch
alias gpsh='git push'                     # Update remote refs along with associated objects
alias gss='git status'                    # Show the working tree status
alias gwho='git shortlog -s -n | head'    # Show top contributors
alias gcnt='git ls-files | wc -l'         # Count number of files in the repository
alias lg='lazygit'                        # Open Lazygit interface
alias grl='gh repo ls 956MB'              # List my repos on GitHub
alias grlf='gh repo ls 956MB --fork'      # List my forked repos on GitHub

# GitHub Copilot CLI function aliases
exp() {
    gh copilot explain "$*"
}
sug() {
    gh copilot suggest "$*"
}
```

---

### Yabai/skhd

[yabairc](./yabai/.yabairc) · [skhdrc](/yabai/..skhdrc)

```bash
alias ystart='yabai --start-service'      # Start yabai service
alias ystop='yabai --stop-service'        # Stop yabai service
alias yupgrade='brew upgrade yabai'       # Upgrade yabai using Homebrew
alias skstart='skhd --start-service'      # Start skhd service
alias skstop='skhd --stop-service'        # Stop skhd service
```

---

### Neovim Summary

Neovim: [v0.10.1](https://github.com/neovim/neovim) · Colorscheme: [vscode.nvim](https://github.com/Mofiqul/vscode.nvim)

[nvim](./nvim/)

```lua
  Total: 103 plugins

  Loaded (86)
    ● align.nvim 0.1ms  start -- https://github.com/Vonr/align.nvim
    ● alpha-nvim 2.75ms  VimEnter -- https://github.com/goolord/alpha-nvim
    ● bufdelete.nvim 0.22ms  start -- https://github.com/famiu/bufdelete.nvim
    ● bufferline.nvim 3.82ms  VeryLazy -- https://github.com/akinsho/bufferline.nvim
    ● ccc.nvim 6.04ms  start -- https://github.com/uga-rosa/ccc.nvim
    ● cheatsheet.nvim 12.82ms  start -- https://github.com/sudormrfbin/cheatsheet.nvim
    ● cmp-buffer 13.06ms  nvim-cmp -- https://github.com/hrsh7th/cmp-buffer
    ● cmp-cmdline 1.5ms  nvim-cmp -- https://github.com/hrsh7th/cmp-cmdline
    ● cmp-nvim-lsp 1.21ms 󰢱 cmp_nvim_lsp  nvim-lspconfig -- https://github.com/hrsh7th/cmp-nvim-lsp
    ● cmp-path 0.99ms  nvim-cmp -- https://github.com/hrsh7th/cmp-path
    ● cmp_luasnip 1.08ms  nvim-cmp -- https://github.com/saadparwaiz1/cmp_luasnip
    ● Comment.nvim 1.33ms  start -- https://github.com/numToStr/Comment.nvim
    ● conform.nvim 1.68ms  BufWritePre -- https://github.com/stevearc/conform.nvim
    ● copilot.lua 6.78ms  InsertEnter -- https://github.com/zbirenbaum/copilot.lua
    ● diffview.nvim 36.41ms  DiffviewOpen -- https://github.com/sindrets/diffview.nvim
    ● fidget.nvim 4.52ms  nvim-lspconfig -- https://github.com/j-hui/fidget.nvim
    ● FixCursorHold.nvim 0.41ms  neotest -- https://github.com/antoinemadec/FixCursorHold.nvim
    ● flash.nvim 0.82ms  VeryLazy -- https://github.com/folke/flash.nvim
    ● force-cul.nvim 0.59ms  start -- https://github.com/jake-stewart/force-cul.nvim
    ● friendly-snippets 0.05ms  nvim-cmp -- https://github.com/rafamadriz/friendly-snippets
    ● gitsigns.nvim 2.75ms  nvim-scrollbar -- https://github.com/lewis6991/gitsigns.nvim
    ● head.nvim 1.46ms  start
    ● hydra.nvim 0.7ms  multicursors.nvim -- https://github.com/smoka7/hydra.nvim
    ● indent-blankline.nvim 7.54ms  LazyFile -- https://github.com/lukas-reineke/indent-blankline.nvim
    ● lazy.nvim 19.62ms  init.lua -- https://github.com/956MB/lazy.nvim
    ● lazydev.nvim 5.37ms  lua -- https://github.com/folke/lazydev.nvim
    ● lazygit.nvim 2.43ms  <leader>lg -- https://github.com/kdheepak/lazygit.nvim
    ● LazyVim 3.85ms  start -- https://github.com/LazyVim/LazyVim
    ● lspkind.nvim 0.46ms  nvim-cmp -- https://github.com/onsails/lspkind.nvim
    ● lualine.nvim 13.24ms  VeryLazy -- https://github.com/nvim-lualine/lualine.nvim
    ● LuaSnip 6.69ms  nvim-cmp -- https://github.com/L3MON4D3/LuaSnip
    ● markdown-preview.nvim 1.25ms  markdown -- https://github.com/iamcco/markdown-preview.nvim
    ● mason-lspconfig.nvim 0.3ms  mason.nvim -- https://github.com/williamboman/mason-lspconfig.nvim
    ● mason-tool-installer.nvim 3.69ms  mason.nvim -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
    ● mason.nvim 25.33ms  VeryLazy -- https://github.com/williamboman/mason.nvim
    ● mini.ai 0.19ms  VeryLazy -- https://github.com/echasnovski/mini.ai
    ● mini.base16 0.17ms  nvim-tree.lua -- https://github.com/echasnovski/mini.base16
    ● mini.indentscope 0.75ms  LazyFile -- https://github.com/echasnovski/mini.indentscope
    ● mini.nvim 1.38ms 󰢱 mini.icons  nvim-web-devicons -- https://github.com/echasnovski/mini.nvim
    ● mini.pairs 1.49ms  VeryLazy -- https://github.com/echasnovski/mini.pairs
    ● multicursors.nvim 5.96ms  VeryLazy -- https://github.com/smoka7/multicursors.nvim
    ● ncks.nvim 0.43ms  start -- https://github.com/956MB/ncks.nvim
    ● neo-tree.nvim 11.73ms 󰢱 neo-tree.events  xcodebuild.nvim -- https://github.com/nvim-neo-tree/neo-tree.nvim
    ● neotest 13.2ms  start -- https://github.com/nvim-neotest/neotest
    ● neotest-rust 0.16ms  neotest -- https://github.com/rouge8/neotest-rust
    ● noice.nvim 1.25ms  VeryLazy -- https://github.com/folke/noice.nvim
    ● nui.nvim 0.2ms  xcodebuild.nvim -- https://github.com/MunifTanjim/nui.nvim
    ● nvim-autopairs 5.44ms  InsertEnter -- https://github.com/windwp/nvim-autopairs
    ● nvim-cmp 40.28ms  InsertEnter -- https://github.com/hrsh7th/nvim-cmp
    ● nvim-dap 32.34ms  start -- https://github.com/mfussenegger/nvim-dap
    ● nvim-dap-ui 0.07ms 󰢱 dapui  nvim-dap -- https://github.com/rcarriga/nvim-dap-ui
    ● nvim-lint 0.88ms  LazyFile -- https://github.com/mfussenegger/nvim-lint
    ● nvim-lsp-file-operations 0.2ms  nvim-tree.lua -- https://github.com/antosha417/nvim-lsp-file-operations
    ● nvim-lspconfig 13.68ms 󰢱 lspconfig.util  mason.nvim -- https://github.com/neovim/nvim-lspconfig
    ● nvim-nio 0.06ms 󰢱 nio  neotest -- https://github.com/nvim-neotest/nvim-nio
    ● nvim-notify 2.76ms  start -- https://github.com/rcarriga/nvim-notify
    ● nvim-scrollbar 3.79ms  start -- https://github.com/petertriho/nvim-scrollbar
    ● nvim-snippets 3.97ms  nvim-cmp -- https://github.com/garymjr/nvim-snippets
    ● nvim-tree.lua 10.26ms 󰢱 nvim-tree.api  xcodebuild.nvim -- https://github.com/nvim-tree/nvim-tree.lua
    ● nvim-treesitter 9.09ms  VeryLazy -- https://github.com/nvim-treesitter/nvim-treesitter
    ● nvim-treesitter-textobjects 4.29ms  VeryLazy -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    ● nvim-ts-autotag 3.94ms  LazyFile -- https://github.com/windwp/nvim-ts-autotag
    ● nvim-ufo 4.43ms  start -- https://github.com/kevinhwang91/nvim-ufo
    ● nvim-web-devicons 3.38ms  start -- https://github.com/nvim-tree/nvim-web-devicons
    ● oil-git-status.nvim 3.3ms  start -- https://github.com/refractalize/oil-git-status.nvim
    ● oil.nvim 2.86ms  oil-git-status.nvim -- https://github.com/stevearc/oil.nvim
    ● overseer.nvim 1.45ms  VeryLazy -- https://github.com/stevearc/overseer.nvim
    ● persistence.nvim 1.62ms  BufReadPre -- https://github.com/folke/persistence.nvim
    ● plenary.nvim 0.38ms  telescope.nvim -- https://github.com/nvim-lua/plenary.nvim
    ● popup.nvim 0.04ms  cheatsheet.nvim -- https://github.com/nvim-lua/popup.nvim
    ● promise-async 0.17ms  nvim-ufo -- https://github.com/kevinhwang91/promise-async
    ● snacks.nvim 0.88ms  start -- https://github.com/folke/snacks.nvim
    ● telescope-file-browser.nvim 0.17ms  start -- https://github.com/nvim-telescope/telescope-file-browser.nvim
    ● telescope-fzf-native.nvim 4.58ms  telescope.nvim -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
    ● telescope-ui-select.nvim 0.1ms  telescope.nvim -- https://github.com/nvim-telescope/telescope-ui-select.nvim
    ● telescope.nvim 12.48ms  cheatsheet.nvim -- https://github.com/nvim-telescope/telescope.nvim
    ● tiny-code-action.nvim 3.83ms  LspAttach -- https://github.com/rachartier/tiny-code-action.nvim
    ● todo-comments.nvim 2.86ms  VimEnter -- https://github.com/folke/todo-comments.nvim
    ● toggle-lsp-diagnostics.nvim 0.71ms  start -- https://github.com/WhoIsSethDaniel/toggle-lsp-diagnostics.nvim
    ● trouble.nvim 1.31ms 󰢱 trouble  lualine.nvim -- https://github.com/folke/trouble.nvim
    ● ts-comments.nvim 0.51ms  VeryLazy -- https://github.com/folke/ts-comments.nvim
    ● vim-kitty 0.4ms  start -- https://github.com/fladson/vim-kitty
    ● vim-sleuth 0.67ms  start -- https://github.com/tpope/vim-sleuth
    ● vscode.nvim 1.58ms colorscheme vscode  LazyVim
    ● which-key.nvim 0.69ms  VeryLazy -- https://github.com/folke/which-key.nvim
    ● xcodebuild.nvim 29.94ms  nvim-dap -- https://github.com/wojciech-kulik/xcodebuild.nvim

  Not Loaded (13)
    ○ catppuccin -- https://github.com/catppuccin/nvim
    ○ dressing.nvim -- https://github.com/stevearc/dressing.nvim
    ○ go.nvim  go  gomod -- https://github.com/ray-x/go.nvim
    ○ grug-far.nvim  <leader>sr (v)  <leader>sr  GrugFar -- https://github.com/MagicDuck/grug-far.nvim
    ○ guihua.lua  go.nvim -- https://github.com/ray-x/guihua.lua
    ○ gx.nvim  gx (v)  gx  Browse -- https://github.com/chrishrb/gx.nvim
    ○ mini.icons -- https://github.com/echasnovski/mini.icons
    ○ quicker.nvim  FileType qf -- https://github.com/stevearc/quicker.nvim
    ○ rainbow_csv.nvim  csv  tsv  csv_semicolon  csv_whitespace  csv_pipe  rfc_csv  rfc_semicolon  RainbowDelimSimple  RainbowDelimQuoted  RainbowMultiDelim  RainbowAlign  RainbowDelim -- https://github.com/cameron-wags/rainbow_csv.nvim
    ○ toggleterm.nvim  <leader>vt  <C-\>  <leader>ht  ToggleTerm -- https://github.com/akinsho/toggleterm.nvim
    ○ vim-dadbod  vim-dadbod-ui -- https://github.com/tpope/vim-dadbod
    ○ vim-dadbod-completion  plsql  mysql  sqlite  sql  vim-dadbod-ui -- https://github.com/kristijanhusak/vim-dadbod-completion
    ○ vim-dadbod-ui  DBUI  DBUIToggle  DBUIAddConnection  DBUIFindBuffer -- https://github.com/kristijanhusak/vim-dadbod-ui

  Disabled (4)
    ○ neodev.nvim  nvim-lspconfig -- https://github.com/folke/neodev.nvim
    ○ nvim -- https://github.com/catppuccin/nvim
    ○ project-explorer.nvim -- https://github.com/Rics-Dev/project-explorer.nvim
    ○ tokyonight.nvim -- https://github.com/folke/tokyonight.nvim
```

```python
                 -- --                    Project: dotfiles (2 branches)
         --                 -- @@@@       HEAD: 28186e2 (main, origin/main)
      --      @@@@@@@@@@@     @@@@@@      Pending: 1+- 4+
           @@@@@@@@@@@@@@@@@   @@@@       Created: 8 months ago
  --     @@@@@@@@@@@@@@****@@@     --     Languages:                                
 --    @@@@@@@@@@@@@@@******@@@@    --               ● Lua (94.9 %) ● BASH (1.8 %)
      @@@@@@@@@@@@@@@@@****@@@@@@                    ● Shell (1.4 %) ● Python (1.1 %)
--   @@@**@@@@@@@@@@@@@@@@@@@@@@@@   --              ● Scheme (0.3 %) ● Zsh (0.2 %)
--   @@@**@@@@@@**@@**@@******@@@@   --              ● Other (0.2 %) 
     @@@**@@@@@@**@@**@**@@@**@@@@        Authors: 96% Alexander Bays <bays@956mb.com> 72
--   @@@**@@@@@@**@@**@@@*****@@@@   --             4% 956MB <bays@956mb.com> 3
--   @@@**@@@@@@**@@**@***@@**@@@@   --   Last change: 19 minutes ago
      @@*******@******@********@@         URL: https://github.com/956MB/dotfiles.git
 --    @@@@@@@@@@@@@@@@@@@@@@@@@    --    Commits: 75
  --     @@@@@@@@@@@@@@@@@@@@@     --     Churn (2): kitty/kitty.conf 2
           @@@@@@@@@@@@@@@@@                         nvim/init.lua 1
      --      @@@@@@@@@@@      --                    …/config/keymaps.lua 1
         --                 --            Lines of code: 14836
                 -- --                    Size: 21.04 MiB (82 files)
                                          License: MIT
```

## License

[MIT license](./LICENSE)

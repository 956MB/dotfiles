
![dashboard](./img/dashboard.png)
![neo-tree](./img/neo-tree.png)
![lazy](./img/lazy.png)
![xcode](./img/xcode.png)

<sub>These screenshots are not up to date anymore. Taking new ones just like this is annoying</sub>

### Aliases

##### General

[zshrc](./zsh/.zshrc)

```bash
alias v='nvim'                            # Open neovim
alias nv='nvim'                           # Open neovim (alternative)
alias z-='z -'                            # Navigate to previous directory using zoxide
alias cd..='z ..'                         # Go up one directory using zoxide
alias z..='z ..'                          # Go up one directory using zoxide (alternative)
alias ..='z ..'                           # Go up one directory using zoxide (another alternative)
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
alias resh="source ~/.zshrc"              # Reload the .zshrc configuration
alias vzsh='kitty @ launch --type=tab nvim --remote-silent ~/.zshrc'  # Edit .zshrc in a new Kitty tab using Neovim
alias vlua='kitty @ launch --type=tab nvim --remote-silent ~/dotfiles/nvim'  # Edit Neovim config in a new Kitty tab
alias monkeytype='z ~/Dev/monkeytype-24.22.0/; pnpm dev-fe'  # Navigate to monkeytype directory and start development server
alias zfq='zoxide query -l -s | less'     # List zoxide query results in less
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
alias gi='git init'                       # Initialize a new Git repository
alias gl='git log'                        # Show commit logs
alias gp='git pull'                       # Fetch from and integrate with another repository or a local branch
alias gpsh='git push'                     # Update remote refs along with associated objects
alias gss='git status'                    # Show the working tree status
alias gwho='git shortlog -s -n | head'    # Show top contributors
alias gcnt='git ls-files | wc -l'         # Count number of files in the repository
alias lg='lazygit'                        # Open Lazygit interface
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

#### Neovim Summary

Neovim: [v0.9.5](https://github.com/neovim/neovim) · LazyVim: [v10.22.0](https://github.com/LazyVim/LazyVim) · Colorscheme: [github_dark_colorblind](https://github.com/projekt0n/github-nvim-theme)

[nvim](./nvim/)

```lua
  Total: 101 plugins

  Loaded (77)
    ● align.nvim 0.23ms  start                                   -- https://github.com/Vonr/align.nvim
    ● alpha-nvim 3.52ms  VimEnter                                -- https://github.com/goolord/alpha-nvim
    ● bufdelete.nvim 0.83ms  start                               -- https://github.com/famiu/bufdelete.nvim
    ● bufferline.nvim 3.82ms  VeryLazy                           -- https://github.com/akinsho/bufferline.nvim
    ● cheatsheet.nvim 27.55ms  start                             -- https://github.com/sudormrfbin/cheatsheet.nvim
    ● cmp-buffer 12.53ms  nvim-cmp                               -- https://github.com/hrsh7th/cmp-buffer
    ● cmp-cmdline 2.6ms  nvim-cmp                                -- https://github.com/hrsh7th/cmp-cmdline
    ● cmp-nvim-lsp 1.35ms 󰢱 cmp_nvim_lsp  nvim-lspconfig         -- https://github.com/hrsh7th/cmp-nvim-lsp
    ● cmp-path 1.16ms  nvim-cmp                                  -- https://github.com/hrsh7th/cmp-path
    ● cmp_luasnip 2.54ms  nvim-cmp                               -- https://github.com/saadparwaiz1/cmp_luasnip
    ● Comment.nvim 2.39ms  start                                 -- https://github.com/numToStr/Comment.nvim
    ● conform.nvim 1.58ms  BufWritePre                           -- https://github.com/stevearc/conform.nvim
    ● copilot.lua 4ms  InsertEnter                               -- https://github.com/zbirenbaum/copilot.lua
    ● fidget.nvim 3.61ms  nvim-lspconfig                         -- https://github.com/j-hui/fidget.nvim
    ● flash.nvim 3.59ms  VeryLazy                                -- https://github.com/folke/flash.nvim
    ● friendly-snippets 0.29ms  nvim-cmp                         -- https://github.com/rafamadriz/friendly-snippets
    ● gitsigns.nvim 5.28ms  nvim-scrollbar                       -- https://github.com/lewis6991/gitsigns.nvim
    ● harpoon 0.07ms 󰢱 harpoon  telescope.nvim                   -- https://github.com/ThePrimeagen/harpoon
    ● head.nvim 2.41ms  start                                    -- https://github.com/956MB/head.nvim
    ● hydra.nvim 0.58ms  multicursors.nvim                       -- https://github.com/smoka7/hydra.nvim
    ● indent-blankline.nvim 2.54ms  LazyFile                     -- https://github.com/lukas-reineke/indent-blankline.nvim
    ● lazy.nvim 19.23ms  init.lua                                -- https://github.com/956MB/lazy.nvim
    ● lazydev.nvim 1.34ms  lua                                   -- https://github.com/folke/lazydev.nvim
    ● lazygit.nvim 3.22ms  <leader>lg                            -- https://github.com/kdheepak/lazygit.nvim
    ● LazyVim 4.34ms  start                                      -- https://github.com/LazyVim/LazyVim
    ● lspkind.nvim 0.69ms  nvim-cmp                              -- https://github.com/onsails/lspkind.nvim
    ● lualine.nvim 39.32ms  VeryLazy                             -- https://github.com/nvim-lualine/lualine.nvim
    ● LuaSnip 11.38ms  nvim-cmp                                  -- https://github.com/L3MON4D3/LuaSnip
    ● mason-lspconfig.nvim 0.35ms  mason.nvim                    -- https://github.com/williamboman/mason-lspconfig.nvim
    ● mason-tool-installer.nvim 3.59ms  mason.nvim               -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
    ● mason.nvim 22.65ms  VeryLazy                               -- https://github.com/williamboman/mason.nvim
    ● mini.ai 0.44ms  VeryLazy                                   -- https://github.com/echasnovski/mini.ai
    ● mini.base16 0.19ms  nvim-tree.lua                          -- https://github.com/echasnovski/mini.base16
    ● mini.indentscope 0.84ms  LazyFile                          -- https://github.com/echasnovski/mini.indentscope
    ● mini.nvim 1.96ms  start                                    -- https://github.com/echasnovski/mini.nvim
    ● mini.pairs 1.63ms  VeryLazy                                -- https://github.com/echasnovski/mini.pairs
    ● multicursors.nvim 5.97ms  VeryLazy                         -- https://github.com/smoka7/multicursors.nvim
    ● ncks.nvim 0.71ms  start                                    -- https://github.com/956MB/ncks.nvim
    ● neo-tree.nvim 13.37ms 󰢱 neo-tree.events  xcodebuild.nvim   -- https://github.com/nvim-neo-tree/neo-tree.nvim
    ● noice.nvim 4.98ms  VeryLazy                                -- https://github.com/folke/noice.nvim
    ● nui.nvim 0.21ms  xcodebuild.nvim                           -- https://github.com/MunifTanjim/nui.nvim
    ● nvim-autopairs 2.61ms  InsertEnter                         -- https://github.com/windwp/nvim-autopairs
    ● nvim-cmp 49.5ms  InsertEnter                               -- https://github.com/hrsh7th/nvim-cmp
    ● nvim-colorizer.lua 2.98ms  start                           -- https://github.com/norcalli/nvim-colorizer.lua
    ● nvim-dap 48.02ms  start                                    -- https://github.com/mfussenegger/nvim-dap
    ● nvim-dap-ui 0.37ms 󰢱 dapui  nvim-dap                       -- https://github.com/rcarriga/nvim-dap-ui
    ● nvim-lint 1.09ms  LazyFile                                 -- https://github.com/mfussenegger/nvim-lint
    ● nvim-lsp-file-operations 0.24ms  nvim-tree.lua             -- https://github.com/antosha417/nvim-lsp-file-operations
    ● nvim-lspconfig 13.4ms 󰢱 lspconfig.util  mason.nvim         -- https://github.com/neovim/nvim-lspconfig
    ● nvim-nio 0.27ms  nvim-dap-ui                               -- https://github.com/nvim-neotest/nvim-nio
    ● nvim-notify 3.24ms  noice.nvim                             -- https://github.com/rcarriga/nvim-notify
    ● nvim-scrollbar 5.74ms  start                               -- https://github.com/petertriho/nvim-scrollbar
    ● nvim-snippets 8.02ms  nvim-cmp                             -- https://github.com/garymjr/nvim-snippets
    ● nvim-tree.lua 14.68ms 󰢱 nvim-tree.api  xcodebuild.nvim     -- https://github.com/nvim-tree/nvim-tree.lua
    ● nvim-treesitter 10.8ms  VeryLazy                           -- https://github.com/nvim-treesitter/nvim-treesitter
    ● nvim-treesitter-textobjects 3.11ms  VeryLazy               -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    ● nvim-ts-autotag 3.29ms  LazyFile                           -- https://github.com/windwp/nvim-ts-autotag
    ● nvim-web-devicons 18.58ms  start                           -- https://github.com/nvim-tree/nvim-web-devicons
    ● obsidian.nvim 8.76ms  markdown                             -- https://github.com/epwalsh/obsidian.nvim
    ● oil.nvim 3.42ms  start                                     -- https://github.com/stevearc/oil.nvim
    ● persistence.nvim 1.33ms 󰢱 persistence  lua                 -- https://github.com/folke/persistence.nvim
    ● plenary.nvim 0.77ms  telescope.nvim                        -- https://github.com/nvim-lua/plenary.nvim
    ● popup.nvim 0.05ms  cheatsheet.nvim                         -- https://github.com/nvim-lua/popup.nvim
    ● telescope-file-browser.nvim 0.19ms  start                  -- https://github.com/nvim-telescope/telescope-file-browser.nvim
    ● telescope-fzf-native.nvim 6.2ms  telescope.nvim            -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
    ● telescope-ui-select.nvim 0.07ms  telescope.nvim            -- https://github.com/nvim-telescope/telescope-ui-select.nvim
    ● telescope.nvim 26.72ms  cheatsheet.nvim                    -- https://github.com/nvim-telescope/telescope.nvim
    ● tiny-code-action.nvim 2.25ms  LspAttach                    -- https://github.com/rachartier/tiny-code-action.nvim
    ● todo-comments.nvim 3.07ms  VimEnter                        -- https://github.com/folke/todo-comments.nvim
    ● toggle-lsp-diagnostics.nvim 2.08ms  start                  -- https://github.com/WhoIsSethDaniel/toggle-lsp-diagnostics.nvim
    ● trouble.nvim 2.45ms 󰢱 trouble  lualine.nvim                -- https://github.com/folke/trouble.nvim
    ● ts-comments.nvim 0.66ms  VeryLazy                          -- https://github.com/folke/ts-comments.nvim
    ● vim-kitty 0.51ms  start                                    -- https://github.com/fladson/vim-kitty
    ● vim-sleuth 1.27ms  start                                   -- https://github.com/tpope/vim-sleuth
    ● vscode.nvim 1.98ms colorscheme vscode  LazyVim             -- https://github.com/Mofiqul/vscode.nvim
    ● which-key.nvim 1.78ms  VeryLazy                            -- https://github.com/folke/which-key.nvim
    ● xcodebuild.nvim 41.23ms  nvim-dap                          -- https://github.com/wojciech-kulik/xcodebuild.nvim

  Not Loaded (15)
    ○ diffview.nvim  DiffviewOpen  DiffviewClose  DiffviewToggleFiles  DiffviewFocusFiles  -- https://github.com/sindrets/diffview.nvim
    ○ dressing.nvim                                              -- https://github.com/stevearc/dressing.nvim
    ○ go.nvim  gomod  go                                         -- https://github.com/ray-x/go.nvim
    ○ guihua.lua  go.nvim                                        -- https://github.com/ray-x/guihua.lua
    ○ gx.nvim  Browse  gx  gx (v)                                -- https://github.com/chrishrb/gx.nvim
    ○ luvit-meta                                                 -- https://github.com/Bilal2453/luvit-meta
    ○ markdown-preview.nvim                                      -- https://github.com/iamcco/markdown-preview.nvim
    ○ nvim-spectre  Spectre  <leader>sr                          -- https://github.com/nvim-pack/nvim-spectre
    ○ quicker.nvim  FileType qf                                  -- https://github.com/stevearc/quicker.nvim
    ○ rainbow_csv.nvim  RainbowDelimQuoted  RainbowMultiDelim  RainbowAlign  RainbowDelim  RainbowDelimSimple  csv_whitespace  csv_pipe  rfc_csv  rfc_semicolon  csv  tsv  csv_semicolon  -- https://github.com/cameron-wags/rainbow_csv.nvim
    ○ toggleterm.nvim  ToggleTerm  <leader>vt  <C-\>  <leader>ht -- https://github.com/akinsho/toggleterm.nvim
    ○ vim-dadbod  vim-dadbod-ui                                  -- https://github.com/tpope/vim-dadbod
    ○ vim-dadbod-completion  sqlite  sql  mysql  plsql  vim-dadbod-ui  -- https://github.com/kristijanhusak/vim-dadbod-completion
    ○ vim-dadbod-ui  DBUIFindBuffer  DBUI  DBUIToggle  DBUIAddConnection  -- https://github.com/kristijanhusak/vim-dadbod-ui
```

```python
                 -- --                    Project: dotfiles (2 branches)
         --                 -- @@@@       HEAD: da83b9e (main)
      --      @@@@@@@@@@@     @@@@@@      Pending: 1+- 1+
           @@@@@@@@@@@@@@@@@   @@@@       Created: 2 months ago
  --     @@@@@@@@@@@@@@****@@@     --     Languages:                            
 --    @@@@@@@@@@@@@@@******@@@@    --               ● Lua (88.2 %) ● BASH (4.9 %)
      @@@@@@@@@@@@@@@@@****@@@@@@                    ● Shell (3.9 %) ● Python (2.0 %)
--   @@@**@@@@@@@@@@@@@@@@@@@@@@@@   --              ● Zsh (1.1 %) 
--   @@@**@@@@@@**@@**@@******@@@@   --   Author: 100% Alexander Bays <bays@956mb.com> 49
     @@@**@@@@@@**@@**@**@@@**@@@@        Last change: 4 minutes ago
--   @@@**@@@@@@**@@**@@@*****@@@@   --   URL: https://github.com/956MB/dotfiles.git
--   @@@**@@@@@@**@@**@***@@**@@@@   --   Commits: 49
      @@*******@******@********@@         Churn (2): scripts/stringify 2
 --    @@@@@@@@@@@@@@@@@@@@@@@@@    --               …/config/autocmds.lua 1
  --     @@@@@@@@@@@@@@@@@@@@@     --                …/plugins/lsp.lua 1
           @@@@@@@@@@@@@@@@@              Lines of code: 3049
      --      @@@@@@@@@@@      --         Size: 1.47 MiB (60 files)
         --                 --            License: MIT
                 -- --                 
```

## License

[MIT license](./LICENSE)

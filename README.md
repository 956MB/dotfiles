
![dashboard](./img/dashboard.png)
![neo-tree](./img/neo-tree.png)
![lazy](./img/lazy.png)
![xcode](./img/xcode.png)

### Aliases

##### General

[zshrc](./zsh/.zshrc)

```bash
alias v='nvim' nv='nvim'
alias cd..='cd ..'
alias l='ls -t'
alias ll='ls -altrF'
alias lsa='ls -hla'
alias lsr='ls -lR'
alias lsf='ls -1 | wc -l'
alias lss='du -sh *'
alias la='ls -A'
alias ls='ls -CF'
alias cls='clear'
alias oldtop="/usr/bin/top"
alias nf="neofetch"
alias of="onefetch --no-color-palette --include-hidden -E"
alias onefetch="onefetch --no-color-palette --include-hidden -E"
alias ep="echo $PATH"
alias resh="source ~/.zshrc"
alias vzsh='kitty @ launch --type=tab nvim --remote-silent ~/.zshrc'
alias vlua='kitty @ launch --type=tab nvim --remote-silent ~/dotfiles/nvim'
```

##### Git

```bash
alias ga='git add'
alias gaa='git add .'
alias gaaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gcr='git clone'
alias gd='git diff'
alias gi='git init'
alias gl='git log'
alias gp='git pull'
alias gpsh='git push'
alias gss='git status'
alias gcnt='git ls-files | wc -l'
alias lg='lazygit'
```

---

### Yabai/skhd

[yabairc](./yabai/.yabairc)
[skhdrc](/yabai/..skhdrc)

```bash
alias ystart='yabai --start-service'
alias ystop='yabai --stop-service'
alias yupgrade='brew upgrade yabai'
alias skstart='skhd --start-service'
alias skstop='skhd --stop-service'
```

---

#### Neovim Summary

Neovim: [v0.9.5](https://github.com/neovim/neovim) · LazyVim: [v10.22.0](https://github.com/LazyVim/LazyVim) · Colorscheme: [github_dark_colorblind](https://github.com/projekt0n/github-nvim-theme)

[nvim](./nvim/)

```lua
Total: 86 plugins

  Clean (6)
    ○ dashboard-nvim 
    ○ habamax.nvim 
    ○ lazy.nvim 
    ○ ncks.nvim 
    ○ nvim-numbertoggle 
    ○ oxocarbon.nvim 

  Loaded (65)
    ● align.nvim 0.02ms  start -- https://github.com/Vonr/align.nvim
    ● alpha-nvim 1.91ms  VimEnter -- https://github.com/goolord/alpha-nvim
    ● bufferline.nvim 2.76ms  VeryLazy -- https://github.com/akinsho/bufferline.nvim
    ● cmp-buffer 17.33ms  nvim-cmp -- https://github.com/hrsh7th/cmp-buffer
    ● cmp-cmdline 1.12ms  nvim-cmp -- https://github.com/hrsh7th/cmp-cmdline
    ● cmp-nvim-lsp 1.06ms 󰢱 cmp_nvim_lsp  nvim-lspconfig -- https://github.com/hrsh7th/cmp-nvim-lsp
    ● cmp-path 0.97ms  nvim-cmp -- https://github.com/hrsh7th/cmp-path
    ● cmp_luasnip 0.93ms  nvim-cmp -- https://github.com/saadparwaiz1/cmp_luasnip
    ● Comment.nvim 0.9ms  start -- https://github.com/numToStr/Comment.nvim
    ● conform.nvim 10.84ms  start -- https://github.com/stevearc/conform.nvim
    ● copilot.lua 2.58ms  InsertEnter -- https://github.com/zbirenbaum/copilot.lua
    ● fidget.nvim 3.38ms  nvim-lspconfig -- https://github.com/j-hui/fidget.nvim
    ● flash.nvim 0.85ms  VeryLazy -- https://github.com/folke/flash.nvim
    ● friendly-snippets 18.15ms  LuaSnip -- https://github.com/rafamadriz/friendly-snippets
    ● github-nvim-theme 0.17ms colorscheme github_dark_colorblind  LazyVim -- https://github.com/projekt0n/github-nvim-theme
    ● gitsigns.nvim 1.24ms  nvim-scrollbar -- https://github.com/lewis6991/gitsigns.nvim
    ● go.nvim 12.35ms  CmdlineEnter -- https://github.com/ray-x/go.nvim
    ● guihua.lua 1.92ms  go.nvim -- https://github.com/ray-x/guihua.lua
    ● harpoon 0.03ms 󰢱 harpoon  telescope.nvim -- https://github.com/ThePrimeagen/harpoon
    ● hydra.nvim 0.48ms  multicursors.nvim -- https://github.com/smoka7/hydra.nvim
    ● indent-blankline.nvim 5.47ms  LazyFile -- https://github.com/lukas-reineke/indent-blankline.nvim
    ● lazy.nvim 11.29ms  init.lua -- https://github.com/folke/lazy.nvim
    ● LazyVim 2.47ms  start -- https://github.com/LazyVim/LazyVim
    ● lspkind.nvim 0.04ms  nvim-cmp -- https://github.com/onsails/lspkind.nvim
    ● lualine.nvim 6.76ms  VeryLazy -- https://github.com/nvim-lualine/lualine.nvim
    ● LuaSnip 20.15ms  nvim-cmp -- https://github.com/L3MON4D3/LuaSnip
    ● mason-lspconfig.nvim 0.53ms  nvim-lspconfig -- https://github.com/williamboman/mason-lspconfig.nvim
    ● mason-tool-installer.nvim 1.95ms  nvim-lspconfig -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
    ● mason.nvim 10.18ms  conform.nvim -- https://github.com/williamboman/mason.nvim
    ● mini.ai 4.01ms  VeryLazy -- https://github.com/echasnovski/mini.ai
    ● mini.comment 0.23ms  VeryLazy -- https://github.com/echasnovski/mini.comment
    ● mini.indentscope 0.56ms  LazyFile -- https://github.com/echasnovski/mini.indentscope
    ● mini.nvim 0.74ms  start -- https://github.com/echasnovski/mini.nvim
    ● mini.pairs 1.72ms  VeryLazy -- https://github.com/echasnovski/mini.pairs
    ● multicursors.nvim 5.24ms  VeryLazy -- https://github.com/smoka7/multicursors.nvim
    ● ncks.nvim 0.29ms  start -- https://github.com/956MB/ncks.nvim
    ● neo-tree.nvim 8.67ms 󰢱 neo-tree.events  xcodebuild.nvim -- https://github.com/nvim-neo-tree/neo-tree.nvim
    ● neoconf.nvim 0.1ms 󰢱 neoconf.plugins  neodev.nvim -- https://github.com/folke/neoconf.nvim
    ● neodev.nvim 1.87ms  nvim-lspconfig -- https://github.com/folke/neodev.nvim
    ● nui.nvim 0.04ms  xcodebuild.nvim -- https://github.com/MunifTanjim/nui.nvim
    ● nvim-autopairs 2ms  InsertEnter -- https://github.com/windwp/nvim-autopairs
    ● nvim-cmp 45.2ms  InsertEnter -- https://github.com/hrsh7th/nvim-cmp
    ● nvim-lint 0.72ms  LazyFile -- https://github.com/mfussenegger/nvim-lint
    ● nvim-lspconfig 15.26ms  LazyFile -- https://github.com/neovim/nvim-lspconfig
    ● nvim-notify 1.99ms 󰢱 notify  LazyVim -- https://github.com/rcarriga/nvim-notify
    ● nvim-scrollbar 1.68ms  start -- https://github.com/petertriho/nvim-scrollbar
    ● nvim-treesitter 5.4ms  VeryLazy -- https://github.com/nvim-treesitter/nvim-treesitter
    ● nvim-treesitter-context 1.53ms  LazyFile -- https://github.com/nvim-treesitter/nvim-treesitter-context
    ● nvim-treesitter-textobjects 2.71ms  nvim-treesitter -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    ● nvim-ts-autotag 1.89ms  LazyFile -- https://github.com/windwp/nvim-ts-autotag
    ● nvim-web-devicons 18ms  telescope.nvim -- https://github.com/nvim-tree/nvim-web-devicons
    ● oil.nvim 1.55ms 󰢱 oil  xcodebuild.nvim -- https://github.com/stevearc/oil.nvim
    ● persistence.nvim 1.96ms 󰢱 persistence  lua -- https://github.com/folke/persistence.nvim
    ● plenary.nvim 0.2ms  telescope.nvim -- https://github.com/nvim-lua/plenary.nvim
    ● telescope-file-browser.nvim 0.35ms  start -- https://github.com/nvim-telescope/telescope-file-browser.nvim
    ● telescope-fzf-native.nvim 2.87ms  telescope.nvim -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
    ● telescope-ui-select.nvim 0.03ms  telescope.nvim -- https://github.com/nvim-telescope/telescope-ui-select.nvim
    ● telescope.nvim 33.67ms  xcodebuild.nvim -- https://github.com/nvim-telescope/telescope.nvim
    ● todo-comments.nvim 1.16ms  VimEnter -- https://github.com/folke/todo-comments.nvim
    ● toggle-lsp-diagnostics.nvim 0.53ms  start -- https://github.com/WhoIsSethDaniel/toggle-lsp-diagnostics.nvim
    ● trouble.nvim 3.46ms 󰢱 trouble  lua -- https://github.com/folke/trouble.nvim
    ● vim-illuminate 1.51ms  LazyFile -- https://github.com/RRethy/vim-illuminate
    ● vim-sleuth 0.33ms  start -- https://github.com/tpope/vim-sleuth
    ● which-key.nvim 7.62ms  VimEnter -- https://github.com/folke/which-key.nvim
    ● xcodebuild.nvim 51.38ms  start -- https://github.com/wojciech-kulik/xcodebuild.nvim

  Not Loaded (11)
    ○ catppuccin -- https://github.com/catppuccin/nvim
    ○ dressing.nvim -- https://github.com/stevearc/dressing.nvim
    ○ gx.nvim  Browse  gx (v)  gx -- https://github.com/chrishrb/gx.nvim
    ○ markdown-preview.nvim  MarkdownPreviewToggle  MarkdownPreview  MarkdownPreviewStop  markdown -- https://github.com/iamcco/markdown-preview.nvim
    ○ mini.bufremove  <leader>bd  <leader>bD -- https://github.com/echasnovski/mini.bufremove
    ○ mini.surround  gsF  gsa  gsn  gsf  gsd  gsh  gsr  gsa (v) -- https://github.com/echasnovski/mini.surround
    ○ nvim-spectre  Spectre  <leader>sr -- https://github.com/nvim-pack/nvim-spectre
    ○ nvim-ts-context-commentstring -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
    ○ obsidian.nvim  markdown -- https://github.com/epwalsh/obsidian.nvim
    ○ rainbow_csv.nvim  RainbowDelimQuoted  RainbowMultiDelim  RainbowAlign  RainbowDelim  RainbowDelimSimple  rfc_semicolon  csv  tsv  csv_semicolon  csv_whitespace  csv_pipe  rfc_csv -- https://github.com/cameron-wags/rainbow_csv.nvim
    ○ vim-startuptime  StartupTime -- https://github.com/dstein64/vim-startuptime

  Disabled (4)
    ○ dashboard-nvim -- https://github.com/nvimdev/dashboard-nvim
    ○ noice.nvim -- https://github.com/folke/noice.nvim
    ○ nvim -- https://github.com/catppuccin/nvim
    ○ tokyonight.nvim -- https://github.com/folke/tokyonight.nvim
```

```python
                 -- --                    Project: dotfiles (1 branch)
         --                 -- @@@@       HEAD: c06ed41 (main, origin/main)
      --      @@@@@@@@@@@     @@@@@@      Pending: 7+- 5+
           @@@@@@@@@@@@@@@@@   @@@@       Created: 3 weeks ago
  --     @@@@@@@@@@@@@@****@@@     --     Languages:                              
 --    @@@@@@@@@@@@@@@******@@@@    --               ● Lua (96.2 %) ● Shell (1.3 %)
      @@@@@@@@@@@@@@@@@****@@@@@@                    ● Python (1.2 %) ● BASH (0.9 %)
--   @@@**@@@@@@@@@@@@@@@@@@@@@@@@   --              ● Zsh (0.4 %) 
--   @@@**@@@@@@**@@**@@******@@@@   --   Author: 100% Alexander Bays <bays@956mb.com> 21
     @@@**@@@@@@**@@**@**@@@**@@@@        Last change: 14 hours ago
--   @@@**@@@@@@**@@**@@@*****@@@@   --   URL: https://github.com/956MB/dotfiles.git
--   @@@**@@@@@@**@@**@***@@**@@@@   --   Commits: 21
      @@*******@******@********@@         Churn (1): zsh/.zshrc 1
 --    @@@@@@@@@@@@@@@@@@@@@@@@@    --               README.md 1
  --     @@@@@@@@@@@@@@@@@@@@@     --     Lines of code: 8994
           @@@@@@@@@@@@@@@@@              Size: 1.51 MiB (51 files)
      --      @@@@@@@@@@@      --         License: MIT
         --                 --         
                 -- --
```

## License

[MIT license](./LICENSE)

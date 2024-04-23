
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

Neovim: [v0.9.5](https://github.com/neovim/neovim)
LazyVim: [v10.22.0](https://github.com/LazyVim/LazyVim)
Colorscheme: ['github_dark_colorblind'](https://github.com/projekt0n/github-nvim-theme)

[nvim](./nvim/)

```lua
Total: 82 plugins

Clean (3)
  ○ habamax.nvim 0.03ms  start -- https://github.com/ntk148v/habamax.nvim
  ○ nvim-numbertoggle -- https://github.com/sitiom/nvim-numbertoggle
  ○ oxocarbon.nvim -- https://github.com/nyoom-engineering/oxocarbon.nvim

Loaded (67)
  ● align.nvim 0.09ms  start -- https://github.com/Vonr/align.nvim
  ● bufferline.nvim 2.7ms  VeryLazy -- https://github.com/akinsho/bufferline.nvim
  ● cmp-buffer 4.43ms  nvim-cmp -- https://github.com/hrsh7th/cmp-buffer
  ● cmp-cmdline 1.46ms  nvim-cmp -- https://github.com/hrsh7th/cmp-cmdline
  ● cmp-nvim-lsp 1.69ms 󰢱 cmp_nvim_lsp  nvim-lspconfig -- https://github.com/hrsh7th/cmp-nvim-lsp
  ● cmp-path 1.07ms  nvim-cmp -- https://github.com/hrsh7th/cmp-path
  ● cmp_luasnip 0.88ms  nvim-cmp -- https://github.com/saadparwaiz1/cmp_luasnip
  ● Comment.nvim 0.88ms  start -- https://github.com/numToStr/Comment.nvim
  ● conform.nvim 9.79ms  start -- https://github.com/stevearc/conform.nvim
  ● copilot.lua 3.77ms  InsertEnter -- https://github.com/zbirenbaum/copilot.lua
  ● dashboard-nvim 1.95ms  VimEnter -- https://github.com/nvimdev/dashboard-nvim
  ● fidget.nvim 4.14ms  nvim-lspconfig -- https://github.com/j-hui/fidget.nvim
  ● flash.nvim 1.16ms  VeryLazy -- https://github.com/folke/flash.nvim
  ● friendly-snippets 11.48ms  LuaSnip -- https://github.com/rafamadriz/friendly-snippets
  ● github-nvim-theme 0.82ms colorscheme github_dark_colorblind  LazyVim -- https://github.com/projekt0n/github-nvim-theme
  ● gitsigns.nvim 1.19ms  nvim-scrollbar -- https://github.com/lewis6991/gitsigns.nvim
  ● go.nvim 5.92ms  CmdlineEnter -- https://github.com/ray-x/go.nvim
  ● guihua.lua 1.27ms  go.nvim -- https://github.com/ray-x/guihua.lua
  ● harpoon 0.03ms 󰢱 harpoon  telescope.nvim -- https://github.com/ThePrimeagen/harpoon/tree/harpoon2
  ● hydra.nvim 0.42ms  multicursors.nvim -- https://github.com/anuvyklack/hydra.nvim
  ● indent-blankline.nvim 6.78ms  LazyFile -- https://github.com/lukas-reineke/indent-blankline.nvim
  ● lazy.nvim 10.31ms  init.lua -- https://github.com/folke/lazy.nvim
  ● LazyVim 1.16ms  start -- https://github.com/LazyVim/LazyVim
  ● lspkind.nvim 0.03ms  nvim-cmp -- https://github.com/onsails/lspkind.nvim
  ● lualine.nvim 4.81ms  VeryLazy -- https://github.com/nvim-lualine/lualine.nvim
  ● LuaSnip 13.81ms  nvim-cmp -- https://github.com/L3MON4D3/LuaSnip
  ● markdown-preview.nvim 1.2ms  markdown -- https://github.com/iamcco/markdown-preview.nvim
  ● mason-lspconfig.nvim 0.45ms  nvim-lspconfig -- https://github.com/williamboman/mason-lspconfig.nvim
  ● mason-tool-installer.nvim 2.23ms  nvim-lspconfig -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
  ● mason.nvim 9.56ms  conform.nvim -- https://github.com/williamboman/mason.nvim
  ● mini.ai 3.05ms  VeryLazy -- https://github.com/echasnovski/mini.ai
  ● mini.comment 0.79ms  VeryLazy -- https://github.com/echasnovski/mini.nvim
  ● mini.indentscope 0.81ms  LazyFile -- https://github.com/echasnovski/mini.nvim
  ● mini.nvim 1.08ms  start -- https://github.com/echasnovski/mini.nvim
  ● mini.pairs 1.95ms  VeryLazy -- https://github.com/echasnovski/mini.nvim
  ● multicursors.nvim 2.91ms  VeryLazy -- https://github.com/echasnovski/multicursors.nvim
  ● ncks.nvim 0.41ms  start -- https://github.com/956MB/ncks.nvim
  ● neo-tree.nvim 13.72ms 󰢱 neo-tree.events  xcodebuild.nvim -- https://github.com/nvim-neo-tree/neo-tree.nvim
  ● neoconf.nvim 0.07ms 󰢱 neoconf.plugins  neodev.nvim -- https://github.com/nvimdev/neoconf.nvim
  ● neodev.nvim 1.74ms  nvim-lspconfig -- https://github.com/nvimdev/neodev.nvim
  ● nui.nvim 0.05ms  xcodebuild.nvim -- https://github.com/MunifTanjim/nui.nvim
  ● nvim-autopairs 2.05ms  InsertEnter -- https://github.com/windwp/nvim-autopairs
  ● nvim-cmp 29.42ms 󰢱 cmp  obsidian.nvim -- https://github.com/hrsh7th/nvim-cmp
  ● nvim-lint 1.52ms  LazyFile -- https://github.com/lvimuser/nvim-lint
  ● nvim-lspconfig 17.16ms  LazyFile -- https://github.com/neovim/nvim-lspconfig
  ● nvim-notify 1.31ms 󰢱 notify  LazyVim -- https://github.com/rcarriga/nvim-notify
  ● nvim-scrollbar 1.55ms  start -- https://github.com/petertriho/nvim-scrollbar
  ● nvim-treesitter 5.27ms  VeryLazy -- https://github.com/nvim-treesitter/nvim-treesitter
  ● nvim-treesitter-context 1.53ms  LazyFile -- https://github.com/nvim-treesitter/nvim-treesitter-context
  ● nvim-treesitter-textobjects 3ms  nvim-treesitter -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  ● nvim-ts-autotag 2.25ms  LazyFile -- https://github.com/windwp/nvim-ts-autotag
  ● nvim-web-devicons 17.85ms  telescope.nvim -- https://github.com/nvim-tree/nvim-web-devicons
  ● obsidian.nvim 34.3ms  markdown -- https://github.com/epwalsh/obsidian.nvim
  ● oil.nvim 2.38ms 󰢱 oil  xcodebuild.nvim -- https://github.com/tssm/oil.nvim
  ● persistence.nvim 2.13ms 󰢱 persistence  lua -- https://github.com/folke/persistence.nvim
  ● plenary.nvim 0.21ms  telescope.nvim -- https://github.com/nvim-lua/plenary.nvim
  ● telescope-file-browser.nvim 14.74ms  start -- https://github.com/nvim-telescope/telescope-file-browser.nvim
  ● telescope-fzf-native.nvim 3.25ms  telescope.nvim -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
  ● telescope-ui-select.nvim 0.03ms  telescope.nvim -- https://github.com/nvim-telescope/telescope-ui-select.nvim
  ● telescope.nvim 14.67ms  xcodebuild.nvim -- https://github.com/nvim-telescope/telescope.nvim
  ● todo-comments.nvim 1.07ms  VimEnter -- https://github.com/folke/todo-comments.nvim
  ● toggle-lsp-diagnostics.nvim 0.88ms  start -- https://github.com/lvimuser/toggle-lsp-diagnostics.nvim
  ● trouble.nvim 4.09ms 󰢱 trouble  lua -- https://github.com/folke/trouble.nvim/tree/dev
  ● vim-illuminate 2.53ms  LazyFile -- https://github.com/RRethy/vim-illuminate
  ● vim-sleuth 0.44ms  start -- https://github.com/tpope/vim-sleuth
  ● which-key.nvim 8.38ms  VimEnter -- https://github.com/folke/which-key.nvim
  ● xcodebuild.nvim 81.08ms  start -- https://github.com/wojciech-kulik/xcodebuild.nvim

Not Loaded (9)
  ○ catppuccin -- https://github.com/catppuccin/nvim
  ○ dressing.nvim -- https://github.com/stevearc/dressing.nvim
  ○ gx.nvim  Browse  gx  gx (v) -- https://github.com/jjuri/gx.nvim
  ○ mini.bufremove  <leader>bD  <leader>bd -- https://github.com/echasnovski/mini.nvim
  ○ mini.surround  gsd  gsh  gsF  gsa (v)  gsr  gsf  gsn  gsa -- https://github.com/echasnovski/mini.nvim
  ○ nvim-spectre  Spectre  <leader>sr -- https://github.com/nvim-pack/nvim-spectre
  ○ nvim-ts-context-commentstring -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
  ○ rainbow_csv.nvim  RainbowDelimSimple  RainbowDelimQuoted  RainbowMultiDelim  RainbowAlign  RainbowDelim  rfc_csv  rfc_semicolon  csv  tsv  csv_semicolon  csv_whitespace  csv_pipe -- https://github.com/ngonehali/rainbow_csv.nvim
  ○ vim-startuptime  StartupTime -- https://github.com/dstein64/vim-startuptime

Disabled (3)
  ○ noice.nvim -- https://github.com/folke/noice.nvim
  ○ nvim -- https://github.com/nvim/nvim
  ○ tokyonight.nvim -- https://github.com/folke/tokyonight.nvim
```

## License

[MIT license](./LICENSE)

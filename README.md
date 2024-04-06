```python
                 .dP"Yb            `Yb                            .dP'         
               dP'   d'             88           db             dP'            
                                    88                                         
`Yb.d88b d88b    'Yb    `Yb.d888b   88.d88b.    'Yb `Y8888888b.  'Yb   .d888b. 
 88'   8Y   8b    88     88'    8Y  88P'   Y8    88    .dP'       88   8'   `Yb
 88    8P   88    88     88     8P  88     8P    88  ,dP          88   Yb.   88
 88  ,dP  ,dP    .8P     88   ,dP   88   ,dP    .8P  88     .    .8P       .dP 
 88                      88        .888888888b.      `Yb...dP            .dP'  
 88                      88                            `"""'           .dP'    
.8P                     .8P
```

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

[nvim](./nvim/)

```lua
Total: 67 plugins

  Loaded (27)
    ● bufferline.nvim 3.89ms  VeryLazy
    ● Comment.nvim 2.07ms  start
    ● conform.nvim 17.93ms  start
    ● dashboard-nvim 2.59ms  VimEnter
    ● flash.nvim 1.49ms  VeryLazy
    ● habamax.nvim 0.02ms  start
    ● hydra.nvim 0.45ms  multicursors.nvim
    ● lazy.nvim 16.06ms  init.lua
    ● LazyVim 1.4ms  start
    ● lualine.nvim 5.54ms  VeryLazy
    ● mason.nvim 17.41ms  conform.nvim
    ● mini.ai 4.25ms  VeryLazy
    ● mini.comment 0.32ms  VeryLazy
    ● mini.nvim 1.03ms  start
    ● mini.pairs 0.91ms  VeryLazy
    ● multicursors.nvim 5.38ms  VeryLazy
    ● nvim-notify 3.91ms 󰢱 notify  LazyVim
    ● nvim-treesitter 7.66ms  VeryLazy
    ● nvim-treesitter-textobjects 5.32ms  nvim-treesitter
    ● plenary.nvim 0.37ms  telescope.nvim
    ● telescope-file-browser.nvim 16.77ms  start
    ● telescope-fzf-native.nvim 5.02ms  telescope.nvim
    ● telescope-ui-select.nvim 0.04ms  telescope.nvim
    ● telescope.nvim 16.66ms  telescope-file-browser.nvim
    ● todo-comments.nvim 2.33ms  VimEnter
    ● vim-sleuth 0.71ms  start
    ● which-key.nvim 10.44ms  VimEnter

  Not Loaded (38)
    ○ catppuccin 
    ○ cmp-buffer  nvim-cmp 
    ○ cmp-cmdline  nvim-cmp 
    ○ cmp-nvim-lsp  nvim-cmp 
    ○ cmp-path  nvim-cmp 
    ○ cmp_luasnip  nvim-cmp 
    ○ copilot.lua  InsertEnter  Copilot 
    ○ dressing.nvim 
    ○ fidget.nvim  nvim-lspconfig 
    ○ friendly-snippets  nvim-cmp  LuaSnip 
    ○ gitsigns.nvim  LazyFile 
    ○ go.nvim  gomod  go  CmdlineEnter 
    ○ guihua.lua  go.nvim 
    ○ indent-blankline.nvim  LazyFile 
    ○ lspkind.nvim  nvim-cmp 
    ○ LuaSnip  <tab> (i)  <tab> (s)  <s-tab> (s)  <s-tab> (i)  nvim-cmp 
    ○ mason-lspconfig.nvim  nvim-lspconfig 
    ○ mason-tool-installer.nvim  nvim-lspconfig 
    ○ mini.bufremove  <leader>bD  <leader>bd 
    ○ mini.indentscope  LazyFile 
    ○ mini.surround  gsf  gsn  gsa  gsd  gsa (v)  gsF  gsh  gsr 
    ○ neo-tree.nvim  <leader>fE  <leader>e  <leader>E  <leader>ge  <leader>be  <leader>fe  Neotree 
    ○ neoconf.nvim  Neoconf  nvim-lspconfig 
    ○ neodev.nvim  nvim-lspconfig 
    ○ nui.nvim 
    ○ nvim-autopairs  InsertEnter 
    ○ nvim-cmp  InsertEnter  LuaSnip 
    ○ nvim-lint  LazyFile 
    ○ nvim-lspconfig  LazyFile  go.nvim  neoconf.nvim 
    ○ nvim-spectre  <leader>sr  Spectre 
    ○ nvim-treesitter-context  LazyFile  <leader>ut 
    ○ nvim-ts-autotag  LazyFile 
    ○ nvim-ts-context-commentstring 
    ○ persistence.nvim  BufReadPre  <leader>qd  <leader>qs  <leader>ql 
    ○ tokyonight.nvim 
    ○ trouble.nvim  <leader>xx  <leader>xX  <leader>xL  <leader>xQ  ]q  [q  TroubleToggle  Trouble 
    ○ vim-illuminate  LazyFile  [[  ]] 
    ○ vim-startuptime  StartupTime 

  Disabled (2)
    ○ noice.nvim 
    ○ nvim-web-devicons  lualine.nvim  telescope.nvim
```

## License

[MIT license](./LICENSE)

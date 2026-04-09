-- kanso.nvim is a local fork, added to rtp in pack.lua
require('kanso').setup {
    theme = 'zen',
    background = {
        dark = 'zen',
    },
}
vim.cmd 'colorscheme kanso'

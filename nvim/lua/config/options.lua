--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = false
vim.g.indent_blankline_enabled = false

local opt = vim.opt

-- [[ Setting options ]]
-- See `:help vim.opt`

opt.swapfile = false
opt.list = false

opt.number = true
opt.relativenumber = true

opt.mouse = 'a'

opt.showmode = false

opt.clipboard = 'unnamedplus'
opt.breakindent = true
opt.undofile = true

opt.ignorecase = true
opt.smartcase = true

opt.signcolumn = 'yes'

opt.updatetime = 250
opt.timeoutlen = 300

opt.splitright = true
opt.splitbelow = true

opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

opt.inccommand = 'split'

opt.cursorline = true
opt.tabstop = 4 -- A TAB character looks like 4 spaces
opt.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
opt.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
opt.shiftwidth = 4 -- Number of spaces inserted when indent

opt.scrolloff = 10
opt.hlsearch = true

-- -- Wrap cursor around lines
opt.whichwrap:append '<,>,[,],h,l'

-- Cursor blink and line instead of block
opt.selection = 'exclusive'
opt.virtualedit = 'onemore'
vim.o.guicursor = table.concat({
    'n-v-c:ver25-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100',
    'i-ci-r-cr:ver25-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100',
    'r:ver25-Cursor/lCursor-blinkwait100-blinkon100-blinkoff100',
}, ',')

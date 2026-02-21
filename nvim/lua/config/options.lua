--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true
vim.g.indent_blankline_enabled = false

vim.o.relativenumber = false
vim.opt_global.relativenumber = false

vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.g.sh_fold_enabled = 0

vim.opt.fileformats = 'unix,dos'
vim.opt.fileformat = 'unix'

local opt = vim.opt

-- [[ Setting options ]]
-- See `:help vim.opt`
opt.background = 'dark'
opt.termguicolors = true
vim.wo.spell = false

opt.swapfile = false
opt.list = false

opt.wrap = true
opt.number = true
opt.relativenumber = false

opt.mousemoveevent = true
opt.mouse = 'a'
opt.conceallevel = 2
opt.showmode = false
opt.textwidth = 0

opt.clipboard = 'unnamedplus'
opt.breakindent = true
opt.undofile = true

opt.ignorecase = true
opt.smartcase = true

opt.signcolumn = 'yes'

opt.updatetime = 250
opt.timeoutlen = 300

opt.exrc = true
opt.secure = true

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

opt.scroll = 5
opt.scrolloff = 0
opt.smoothscroll = false
opt.hlsearch = true

-- Wrap cursor around lines
opt.whichwrap:append '<,>,[,],h,l'

-- Block in normal/command, line in insert/visual/select, blink only in insert
opt.selection = 'exclusive'
opt.virtualedit = 'onemore'
vim.o.guicursor = table.concat({
    'n-c:block-Cursor/lCursor',
    'v-sm:ver25-Cursor/lCursor',
    'i-ci:ver25-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100',
    'r-cr-o:hor20-Cursor/lCursor',
}, ',')

-- Config options for Neovide gui (trying)
--
if vim.g.neovide then
    -- blink off:
    vim.o.guicursor = table.concat({
        'n-c:block-Cursor/lCursor',
        'v-sm:ver25-Cursor/lCursor',
        'i-ci:ver25-Cursor/lCursor',
        'r-cr-o:hor20-Cursor/lCursor',
    }, ',')
    vim.o.guifont = 'JetBrainsMonoNL Nerd Font Mono:h13'
    vim.o.linespace = 0
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_cursor_trail_size = 0
    vim.g.neovide_cursor_smooth_blink = false
    vim.g.neovide_refresh_rate_idle = 5
    vim.g.neovide_scroll_animation_length = 0
    vim.g.neovide_remember_window_size = true
    vim.g.neovide_remember_window_position = true
    vim.g.neovide_show_border = true
    vim.g.neovide_floating_shadow = false
end

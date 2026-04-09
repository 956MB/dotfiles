-- [[ vim-sleuth: auto-detect tabstop/shiftwidth ]]
-- No setup needed.

-- [[ nvim-autopairs ]]
require('nvim-autopairs').setup {
    add_pairs = {
        ['('] = ')',
        ['['] = ']',
        ['{'] = '}',
        ["'"] = "'",
        ['"'] = '"',
        ['<'] = '>',
    },
}

-- [[ which-key ]]
require('which-key').setup()
vim.keymap.set('n', '<leader>?', function()
    require('which-key').show { global = false }
end, { desc = 'Buffer Local Keymaps (which-key)' })

-- [[ grug-far: find and replace ]]
require('grug-far').setup {}

-- [[ nvim-rip-substitute ]]
local popupWin = require 'rip-substitute.popup-win'
local origOpen = popupWin.openSubstitutionPopup
---@diagnostic disable-next-line: duplicate-set-field
popupWin.openSubstitutionPopup = function(...)
    local popupBufName = '[RipSubstitute]'
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == popupBufName then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end
    return origOpen(...)
end

vim.keymap.set({ 'n', 'x' }, '<leader>fs', function()
    require('rip-substitute').sub()
end, { desc = ' rip substitute' })

-- [[ gitsigns ]]
require('gitsigns').setup {
    signs = {
        -- ┆, ┊, ┋, ┇, │
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '│' },
        topdelete = { text = '│' },
        changedelete = { text = '│' },
    },
}
require('scrollbar.handlers.gitsigns').setup()

-- [[ nvim-scrollbar ]]
require('scrollbar').setup {
    set_highlights = true,
    marks = {
        Cursor = { text = '─' },
        GitAdd = { text = '┊' },
        GitChange = { text = '┊' },
        GitDelete = { text = '┊' },
    },
}

-- [[ Comment.nvim ]]
require('ts_context_commentstring').setup {
    enable_autocmd = false,
}
require('Comment').setup {
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}

local api = require 'Comment.api'
vim.keymap.set('n', '<C-l>', api.call('toggle.linewise.current', 'g@$'), { expr = true })
vim.keymap.set('v', '<C-l>', api.call('toggle.linewise', 'g@'), { expr = true })

-- [[ multicursor.nvim ]]
local mc = require 'multicursor-nvim'
mc.setup()

local set = vim.keymap.set
set({ 'n', 'x' }, '<A-S-up>', function()
    mc.lineAddCursor(-1)
end)
set({ 'n', 'x' }, '<A-S-down>', function()
    mc.lineAddCursor(1)
end)
set({ 'n', 'x' }, '<C-d>', function()
    mc.matchAddCursor(1)
end)
set({ 'n', 'x' }, '<C-S-d>', function()
    mc.matchAddCursor(-1)
end)

mc.addKeymapLayer(function(layerSet)
    layerSet({ 'n', 'x' }, '<left>', mc.prevCursor)
    layerSet({ 'n', 'x' }, '<right>', mc.nextCursor)
    layerSet({ 'n', 'x' }, '<C-S-d>', mc.deleteCursor)
    layerSet('n', '<esc>', function()
        if not mc.cursorsEnabled() then
            mc.enableCursors()
        else
            mc.clearCursors()
        end
    end)
end)

local hl = vim.api.nvim_set_hl
hl(0, 'MultiCursorCursor', { link = 'Cursor' })
hl(0, 'MultiCursorVisual', { link = 'Visual' })
hl(0, 'MultiCursorSign', { link = 'SignColumn' })
hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
hl(0, 'MultiCursorDisabledCursor', { link = 'Visual' })
hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })

-- [[ align.nvim ]]
vim.keymap.set('x', 'aa', function()
    require('align').align_to_char { length = 1 }
end, { noremap = true, silent = true })

-- [[ trouble.nvim ]]
require('trouble').setup {
    auto_open = false,
    auto_close = false,
    auto_preview = true,
    focus = true,
    auto_jump = false,
    cycle_results = true,
}

local tmap = vim.keymap.set
tmap('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics (Trouble)' })
tmap('n', '<leader>XX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer Diagnostics (Trouble)' })
tmap('n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = 'Symbols (Trouble)' })
tmap('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', { desc = 'LSP Definitions / references / ...' })
tmap('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', { desc = 'Location List (Trouble)' })
tmap('n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix List (Trouble)' })

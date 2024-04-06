local utils = require 'config.utils'

local function map(mode, lhs, rhs, opts)
    local keys = require('lazy.core.handler').handlers.keys
    -- -@cast keys LazyKeysHandler
    -- do not create the keymap if a lazy keys handler exists
    if not keys.active[keys.parse({ lhs, mode = mode }).id] then
        opts = opts or {}
        opts.silent = opts.silent ~= false
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Select all file contents with ctrl+a
map('n', '<C-a>', 'ggVG', { desc = 'Select [A]ll' })

-- Switch J and K keys directions (j: up, k: down)
map('n', 'j', 'k', { desc = 'Up' })
map('n', 'k', 'j', { desc = 'Down' })

-- Move lines up/down using alt+arrow
map('n', '<A-Up>', ':move -2<CR>', { desc = 'Move line(s) Up, (Normal)' })
map('n', '<A-Down>', ':move +<CR>', { desc = 'Move line(s) Down, ()Normal' })
map('x', '<A-Up>', ":move '<-2<CR>gv", { desc = 'Move line(s) Up, (Visual)' })
map('x', '<A-Down>', ":move '>+<CR>gv", { desc = 'Move line(s) Down, (Visual)' })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Remap jump-motions navigation to "alt+[" and "alt+]"
map('n', '<C-o>', '<C-i>', { desc = 'Jump backward' })
map('n', '<C-i>', '<C-o>', { desc = 'Jump forward' })

-- Remap jump to beginnging and end of line to < and >
map('n', 'h', '0', { desc = 'Beginning of line' })
map('n', 'l', '$', { desc = 'End of line' })

-- Map Ctrl + s to escape from insert mode and write ":w"
map('i', '<C-s>', '<ESC>:w<CR>', { desc = '[S]ave' })
map('n', '<C-s>', ':w<CR>', { desc = '[S]save' })

-- Remap tab and shift+tab for indenting
map('n', '<Tab>', ':><CR>', { desc = '[T]ab forward (4, Normal)' })
map('n', '<S-Tab>', ':<<CR>', { desc = '[T]ab backward (4, Normal)' })
map('x', '<Tab>', '>gv', { desc = '[T]ab forward (4, Visual)' })
map('x', '<S-Tab>', '<gv', { desc = '[T]ab backward (4, Visual)' })

-- Remap line delete to ctrl+x
map('n', '<C-x>', 'dd', { desc = '[D]elete Line' })

-- Map left/right subword navigation to ctrl+left / ctrl+right
map('n', '<C-Left>', 'b', { desc = 'Subword navigate left' })
map('n', '<C-Right>', 'w', { desc = 'Subword navigate right' })
map('i', '<C-Left>', '<C-o>b', { desc = 'Subword navigate left (insert mode)' })
map('i', '<C-Right>', '<C-o>w', { desc = 'Subword navigate right (insert mode)' })

-- Source the Neovim configuration file
map('n', '<leader>rr', ':luafile $HOME/dotfiles/nvim/init.lua<CR>', { desc = 'Reload Neovim configuration' })

-- Map the Up key to move the cursor to the beginning of the line on the first line (Normal mode)
map('n', '<Up>', function()
    vim.cmd 'normal! k' -- Move up one line
    vim.cmd 'lua require("config.utils").move_cursor_to_line_edge()'
end, { desc = 'Up & beginning of line' })

-- Map the Down key to move the cursor to the end of the line on the last line (Normal mode)
map('n', '<Down>', function()
    vim.cmd 'normal! j' -- Move down one line
    vim.cmd 'lua require("config.utils").move_cursor_to_line_edge()'
end, { desc = 'Down & end of line' })

-- Map the Up key to move the cursor to the beginning of the line on the first line (Insert mode)
map('i', '<Up>', function()
    vim.cmd 'normal! <C-o>k' -- Move up one line (with <C-o> to temporary enter Normal mode)
    vim.cmd 'lua require("config.utils").move_cursor_to_line_edge()'
    vim.cmd 'startinsert' -- Return to Insert mode
end, { desc = 'Up & beginning of line' })

-- Map the Down key to move the cursor to the end of the line on the last line (Insert mode)
map('i', '<Down>', function()
    vim.cmd 'normal! <C-o>j' -- Move down one line (with <C-o> to temporary enter Normal mode)
    vim.cmd 'lua require("config.utils").move_cursor_to_line_edge()'
    vim.cmd 'startinsert' -- Return to Insert mode
end, { desc = 'Down & end of line' })

-- Write Quit
map('n', '<leader>wq', ':wq<CR>', { desc = 'Write [Q]uit All' })
map('n', '<leader>qq', ':qq<CR>', { desc = 'Write [Q]uit All' })

-- Undo/Redo: 'u' >> 'ctrl+z', 'ctrl+r' >> 'shift+ctrl+z'
map('n', 'u', '<Nop>')
map('n', '<C-Z>', ':undo<CR>', { desc = 'Undo (Normal)' })
map('i', '<C-Z>', '<ESC>:undo<CR>a', { desc = 'Undo (Insert)' })
map('n', '<C-R>', '<Nop>')
map('n', '<S-C-Z>', ':redo<CR>', { desc = 'Redo (Normal)' })
map('i', '<S-C-Z>', '<ESC>:redo<CR>', { desc = 'Redo (Insert)' })
map('n', '<leader>u', '<cmd>Telescope undo<cr>', { desc = 'Undo (Telescope)' })

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Tabs
for i = 1, 9 do
    map('n', '`' .. i, '<cmd>tabn ' .. i .. '<cr>', { desc = 'Go to tab ' .. i })
end

map('n', '`t', '<cmd>tabnew<cr>', { desc = 'New Tab' })
map('n', '`w', '<cmd>tabclose<cr>', { desc = 'Close Tab' })

-- Remap the 'next' and 'previous' tab keymaps to use the tab_loop function
map('n', '`]', function()
    vim.cmd 'lua require("config.utils").tab_loop("next")'
end, { desc = 'Next Tab (loop around)' })

map('n', '`[', function()
    vim.cmd 'lua require("config.utils").tab_loop("prev")'
end, { desc = 'Previous Tab (loop around)' })

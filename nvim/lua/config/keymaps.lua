local utils = require 'config.utils'
local harpoon = require 'harpoon'

harpoon:setup()

local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
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

-- Ctrl+s to save
map('i', '<C-s>', '<ESC>:w<CR>', { desc = '[S]ave' })
map('n', '<C-s>', ':w<CR>', { desc = '[S]save' })

-- Remap tab and shift+tab for indenting
map('n', '<Tab>', ':><CR>', { desc = '[T]ab forward (4, Normal)' })
map('n', '<S-Tab>', ':<<CR>', { desc = '[T]ab backward (4, Normal)' })
map('x', '<Tab>', '>gv', { desc = '[T]ab forward (4, Visual)' })
map('x', '<S-Tab>', '<gv', { desc = '[T]ab backward (4, Visual)' })

-- Remap line delete to ctrl+x
map('n', '<C-x>', 'dd', { desc = '[D]elete Line' })

-- OIL
map('n', '`', '<CMD>Oil<CR>', { desc = 'OIL' })

-- Obsidian
map('n', '<leader>oc', '<cmd>lua require("obsidian").util.toggle_checkbox()<CR>', { desc = '[O]bsidian toggle [c]heckbox' })
map('n', '<leader>ot', '<cmd>ObsidianTemplate<CR>', { desc = 'Insert [O]bsidian [T]emplate' })
map('n', '<leader>ob', '<cmd>ObsidianBacklinks<CR>', { desc = 'Show [O]bsidian [B]acklinks' })
map('n', '<leader>oo', '<cmd>ObsidianOpen<CR>', { desc = '[O]pen in [O]bsidian App' })
map('n', '<leader>os', '<cmd>ObsidianSearch<CR>', { desc = '[O]bsidian [S]earch' })
map('n', '<leader>on', '<cmd>ObsidianNew<CR>', { desc = '[O]bsidian [N]ew Note' })
map('n', '<leader>od', '<cmd>ObsidianDelete<CR>', { desc = '[O]bsidian [D]elete Note' })
map('n', '<leader>op', '<cmd>ObsidianPreview<CR>', { desc = '[O]bsidian [P]review' })
map('n', '<leader>oq', '<cmd>ObsidianQuickSwitch<CR>', { desc = '[O]bsidian [Q]uick Switch' })
map('n', '<leader>ol', '<cmd>ObsidianLinks<CR>', { desc = '[O]bsidian Show [L]inks' })

-- Harpoon
-- NOTE: Next/Previous broken? Or my kebinds just don't work? Fix later
-- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set('n', '<C-S-L>', function()
--     harpoon:list():prev()
-- end, { desc = '[P]revious Harpoon Buffer' })
-- vim.keymap.set('n', '<C-S-P>', function()
--     harpoon:list():next()
-- end, { desc = '[N]ext Harpoon Buffer' })
vim.keymap.set('n', '<leader>a', function()
    harpoon:list():add()
end, { desc = '[A]dd [F]ile to Harpoon' })
vim.keymap.set('n', '<C-e>', function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'Toggle Harpoon [E]xplorer' })
vim.keymap.set('n', '<C-1>', function()
    harpoon:list():select(1)
end, { desc = '[S]elect Harpoon (1)' })
vim.keymap.set('n', '<C-2>', function()
    harpoon:list():select(2)
end, { desc = '[S]elect Harpoon (2)' })
vim.keymap.set('n', '<C-3>', function()
    harpoon:list():select(3)
end, { desc = '[S]elect Harpoon (3)' })
vim.keymap.set('n', '<C-4>', function()
    harpoon:list():select(4)
end, { desc = '[S]elect Harpoon (4)' })

-- Map left/right subword navigation to ctrl+left / ctrl+right
map('n', '<C-Left>', 'b', { desc = 'Subword navigate left' })
map('n', '<C-Right>', 'w', { desc = 'Subword navigate right' })
map('i', '<C-Left>', '<C-o>b', { desc = 'Subword navigate left (insert mode)' })
map('i', '<C-Right>', '<C-o>w', { desc = 'Subword navigate right (insert mode)' })

-- Source the Neovim configuration file
map('n', '<leader>rr', ':luafile $HOME/dotfiles/nvim/init.lua<CR>', { desc = 'Reload Neovim configuration' })

-- Write Quit
map('n', '<leader>wq', function()
    utils.close_neo_tree() -- Close Neo-tree first
    vim.cmd 'wq' -- Then write and quit
end, { desc = '[W]rite and [Q]uit' })

map('n', '<leader>qq', function()
    utils.close_neo_tree() -- Close Neo-tree first
    vim.cmd 'qa' -- Then quit all
end, { desc = '[Q]uit All' })

-- Undo/Redo: 'u' >> 'ctrl+z', 'ctrl+r' >> 'shift+ctrl+z'
map('n', '<C-Z>', ':undo<CR>', { desc = 'Undo (Normal)' })
map('i', '<C-Z>', '<ESC>:undo<CR>a', { desc = 'Undo (Insert)' })
map('n', 'r', ':redo<CR>', { desc = 'Redo (Normal)' })
map('n', '<S-C-Z>', ':redo<CR>', { desc = 'Redo (Normal)' })
map('i', '<S-C-Z>', '<ESC>:redo<CR>', { desc = 'Redo (Insert)' })
map('n', '<leader>u', '<cmd>Telescope undo<cr>', { desc = 'Undo (Telescope)' })

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

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

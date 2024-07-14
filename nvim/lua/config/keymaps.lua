local harpoon = require 'harpoon'
harpoon:setup()

local utils = require 'config.utils'

local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

map('n', '9', '$', { noremap = true, desc = 'Go to end of line' })

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

-- Reload config (sigle file edit)
map('n', '<leader><leader>x', '<cmd>source %<CR>', { desc = 'Reload File' })

-- Ctrl+s to save
map('i', '<C-s>', '<ESC>:w<CR>', { desc = '[S]ave' })
map('n', '<C-s>', ':w<CR>', { desc = '[S]save' })
-- map('i', '<leader>ww', '<ESC>:wa<CR>', { noremap = true, desc = '[S]ave [A]ll' })
-- map('n', '<leader>ww', ':wa<CR>', { noremap = true, desc = '[S]ave [A]ll' })

-- Remap tab and shift+tab for indenting
map('n', '<Tab>', ':><CR>', { desc = '[T]ab forward (4, Normal)' })
map('n', '<S-Tab>', ':<<CR>', { desc = '[T]ab backward (4, Normal)' })
map('x', '<Tab>', '>gv', { desc = '[T]ab forward (4, Visual)' })
map('x', '<S-Tab>', '<gv', { desc = '[T]ab backward (4, Visual)' })

-- Remap line delete to 'ctrl+x'
map('n', '<C-x>', 'dd', { desc = '[D]elete Line' })
map('v', '<C-x>', 'D', { desc = '[D]elete Lines' })

-- Search selected text with '/'
map('v', '/', function()
    vim.cmd 'normal! y'
    local escaped_text = vim.fn.escape(vim.fn.getreg '"', '/\\')
    vim.fn.setreg('/', '\\V' .. escaped_text)
    vim.cmd 'normal! n'
end, { noremap = true, desc = 'Search selected text' })

-- [T]his [T]hing
map('n', '<leader>[[', function()
    utils.surround_and_capitalize()
end, { desc = 'Surround and [T]his [T]hing' })

-- OIL
map('n', '<C-`>', function()
    require('oil').open()
end, { desc = 'OIL' })

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

-- Toggle gitsigns
map('n', '<leader>gs', '<cmd>lua require("gitsigns").toggle_signs()<CR>', { desc = 'Toggle [G]it[S]igns' })

-- Toggle Conceal and Spell (Markdown)
map('n', '<leader>md', function()
    utils.toggle_markdown_display()
end, { desc = 'Toggle [M]arkdown [D]isplay' })
-- Run MarkdownPreview
map('n', '<leader>mp', '<cmd>MarkdownPreview<CR>', { desc = '[M]arkdown [P]review' })
-- Markdown Preview
map('n', '<leader>mp', '<cmd>MarkdownPreview<CR>', { desc = '[M]arkdown [P]review' })

-- todo-comments.nvim and Trouble
map('n', '<leader>td', '<cmd>TodoTrouble<cr>', { desc = 'Show [T]odo [D]iagnostic Comments' })
map('n', '<leader>tm', '<cmd>TodoQuickFix keywords=MINE<cr>', { desc = 'Show [M]y [T]odo Comments' })
map('n', ']t', function()
    require('todo-comments').jump_next { keywords = { 'MINE' } }
end, { desc = 'Next `MINE` todo comment' })
map('n', '[t', function()
    require('todo-comments').jump_prev { keywords = { 'MINE' } }
end, { desc = 'Previous `MINE` todo comment' })

-- Harpoon
-- NOTE: Next/Previous broken? Or my kebinds just don't work? Fix later
-- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set('n', '<C-S-i>', function()
--     harpoon:list():prev()
-- end, { desc = '[P]revious Harpoon Buffer' })
-- vim.keymap.set('n', '<C-S-o>', function()
--     harpoon:list():next()
-- end, { desc = '[N]ext Harpoon Buffer' })
map('n', '<leader>a', function()
    harpoon:list():add()
end, { desc = '[A]dd [F]ile to Harpoon' })
map('n', '<C-1>', function()
    harpoon:list():select(1)
end, { desc = '[S]elect Harpoon (1)' })
map('n', '<C-2>', function()
    harpoon:list():select(2)
end, { desc = '[S]elect Harpoon (2)' })
map('n', '<C-3>', function()
    harpoon:list():select(3)
end, { desc = '[S]elect Harpoon (3)' })
map('n', '<C-4>', function()
    harpoon:list():select(4)
end, { desc = '[S]elect Harpoon (4)' })

-- nvim-tree
map('n', '<leader>E', '<cmd>NvimTreeToggle<CR>', { desc = 'Explorer [N]vimTree' })

-- Bufferline
map('n', '<C-w>', '<cmd>bd<CR>', { desc = '[D]elete Buffer (Tab)' })
map('n', '<leader>co', '<cmd>BufferLineCloseOthers<CR>', { desc = '[C]lose all [O]ther open tabs' })
map('n', '<leader>bp', '<cmd>BufferLineTogglePin<CR>', { desc = 'Toggle [B]uffer [P]in' })
map('n', '-', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Cycle buffers Prev (Left)' })
map('n', '=', '<cmd>BufferLineCycleNext<CR>', { desc = 'Cycle buffers Next (Right)' })
map('n', '<C-->', '<cmd>BufferLineMovePrev<CR>', { desc = 'Move buffer Left' })
map('n', '<C-=>', '<cmd>BufferLineMoveNext<CR>', { desc = 'Move buffer Right' })
for i = 1, 9 do
    map('n', '<leader>' .. i, '<cmd>BufferLineGoToBuffer ' .. i .. '<CR>', { desc = 'Go to buffer ' .. i })
end

-- Split creation/navigation
map('n', '<C-j>', '<C-w>k', { noremap = true, desc = 'Move focus to the split above' })
map('n', '<C-k>', '<C-w>j', { noremap = true, desc = 'Move focus to the split below' })
map('n', '<C-S-j>', '<C-w>h', { noremap = true, desc = 'Move focus to the split on the left' })
map('n', '<C-S-k>', '<C-w>l', { noremap = true, desc = 'Move focus to the split on the right' })
map('n', '<C-,>', function()
    utils.scale_split '-1'
end, { noremap = true, desc = 'Scale the current split by -1' })
map('n', '<C-.>', function()
    utils.scale_split '+1'
end, { noremap = true, desc = 'Scale the current split by +1' })
map('n', '<leader>vs', ':vsplit<CR>', { noremap = true, silent = true })
map('n', '<leader>hs', ':split<CR>', { noremap = true, silent = true })
map('n', '<leader>dd', '<C-w>c', { noremap = true, silent = true })

-- Xcodebuild / sourcekit-lsp
map('n', '<leader>X', '<cmd>XcodebuildPicker<cr>', { desc = 'Show Xcodebuild Actions' })
map('n', '<leader>xf', '<cmd>XcodebuildProjectManager<cr>', { desc = 'Show Project Manager Actions' })
map('n', '<leader>xb', '<cmd>XcodebuildBuild<cr>', { desc = 'Build Project' })
map('n', '<leader>xB', '<cmd>XcodebuildBuildForTesting<cr>', { desc = 'Build For Testing' })
map('n', '<leader>xr', '<cmd>XcodebuildBuildRun<cr>', { desc = 'Build & Run Project' })
map('n', '<leader>xt', '<cmd>XcodebuildTest<cr>', { desc = 'Run Tests' })
map('v', '<leader>xt', '<cmd>XcodebuildTestSelected<cr>', { desc = 'Run Selected Tests' })
map('n', '<leader>xT', '<cmd>XcodebuildTestClass<cr>', { desc = 'Run This Test Class' })
map('n', '<leader>xl', '<cmd>XcodebuildToggleLogs<cr>', { desc = 'Toggle Xcodebuild Logs' })
map('n', '<leader>xc', '<cmd>XcodebuildToggleCodeCoverage<cr>', { desc = 'Toggle Code Coverage' })
map('n', '<leader>xC', '<cmd>XcodebuildShowCodeCoverageReport<cr>', { desc = 'Show Code Coverage Report' })
map('n', '<leader>xe', '<cmd>XcodebuildTestExplorerToggle<cr>', { desc = 'Toggle Test Explorer' })
map('n', '<leader>xs', '<cmd>XcodebuildFailingSnapshots<cr>', { desc = 'Show Failing Snapshots' })
map('n', '<leader>xd', '<cmd>XcodebuildSelectDevice<cr>', { desc = 'Select Device' })
map('n', '<leader>xp', '<cmd>XcodebuildSelectTestPlan<cr>', { desc = 'Select Test Plan' })
map('n', '<leader>xq', '<cmd>Telescope quickfix<cr>', { desc = 'Show QuickFix List' })
map('n', '<leader>xx', '<cmd>XcodebuildQuickfixLine<cr>', { desc = 'Quickfix Line' })
map('n', '<leader>xa', '<cmd>XcodebuildCodeActions<cr>', { desc = 'Show Code Actions' })

-- ncks.nvim
map('n', '<leader>no', '<cmd>NcksOpen<cr>', { desc = '[O]pen [N]cks file' })
map('n', '<leader>nl', '<cmd>NcksList<cr>', { desc = '[L]ist [N]cks files' })
map('n', '<leader>nr', '<cmd>NcksRandom<cr>', { desc = 'Pick [R]andom [N]ick from file' })
map('n', '<leader>nc', '<cmd>NcksCopyAll<cr>', { desc = '[C]opy all [N]icknames from file to clipboard' })
map('n', '<leader>ni', '<cmd>NcksInfo<cr>', { desc = 'Show [N]icks file [I]nfo' })

-- Spectre
map('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', { desc = '[S]pectre Toggle' })

-- Map left/right subword navigation to ctrl+left / ctrl+right
map('n', '<C-Left>', 'b', { desc = 'Subword navigate left' })
map('n', '<C-Right>', 'w', { desc = 'Subword navigate right' })
map('i', '<C-Left>', '<C-o>b', { desc = 'Subword navigate left (insert mode)' })
map('i', '<C-Right>', '<C-o>w', { desc = 'Subword navigate right (insert mode)' })

-- Source the Neovim configuration file
map('n', '<leader>rr', ':luafile $HOME/dotfiles/nvim/init.lua<CR>', { desc = 'Reload Neovim configuration' })

-- Lspmark.nvim
map('n', 'p', function()
    require('lspmark.bookmarks').paste_text()
end, { desc = 'Lspmark [P]aste' })
map('n', '<leader>tb', function()
    require('lspmark.bookmarks').toggle_bookmark()
end, { desc = 'Lspmark [T]oggle [B]ookmark' })
map('n', '<leader>tl', ':Telescope lspmark<CR>', { desc = 'Toggle [L]spmark [T]elescope' })
map('v', 'd', function()
    require('lspmark.bookmarks').delete_visual_selection()
end, { desc = 'Lspmark [D]elete visual selection' })
map('n', 'dd', function()
    require('lspmark.bookmarks').delete_line()
end, { desc = 'Lspmark [D]elete line' })

-- Write Quit
map('n', '<leader>wq', function()
    vim.cmd 'wq'
end, { desc = '[W]rite and [Q]uit' })
map('n', '<leader>qq', function()
    vim.cmd 'qa'
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
-- map('n', '`]', function()
--     vim.cmd 'lua require("config.utils").tab_loop("next")'
-- end, { desc = 'Next Tab (loop around)' })

-- map('n', '`[', function()
--     vim.cmd 'utils.tab_loop("prev")'
-- end, { desc = 'Previous Tab (loop around)' })

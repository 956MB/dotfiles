local harpoon = require 'harpoon'
harpoon:setup()

local utils = require 'config.utils'

local function map(mode, lhs, rhs, desc, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    opts.desc = desc
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

map('n', '9', '$', 'Go to end of line', { noremap = true })

-- Select all file contents with ctrl+a
map('n', '<C-a>', 'ggVG', 'Select [A]ll')

-- Switch J and K keys directions (j: up, k: down)
map('n', 'j', 'k', 'Up')
map('n', 'k', 'j', 'Down')

-- Move lines up/down using alt+arrow
map('n', '<A-Up>', ':move -2<CR>', 'Move line(s) Up, (Normal)')
map('n', '<A-Down>', ':move +<CR>', 'Move line(s) Down, (Normal)')
map('x', '<A-Up>', ":move '<-2<CR>gv", 'Move line(s) Up, (Visual)')
map('x', '<A-Down>', ":move '>+<CR>gv", 'Move line(s) Down, (Visual)')

-- Set highlight on search, but clear on pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Remap jump-motions navigation to "alt+[" and "alt+]"
map('n', '<C-o>', '<C-i>', 'Jump backward')
map('n', '<C-i>', '<C-o>', 'Jump forward')

-- Reload config (sigle file edit)
map('n', '<leader><leader>x', '<cmd>source %<CR>', 'Reload File')

-- Copy all file contents to clipboard
map('n', '<C-S-y>', ':%y+<CR>', 'Copy all to clipboard')

-- Ctrl+s to save
map('i', '<C-s>', '<ESC>:w<CR>', '[S]ave')
map('n', '<C-s>', ':w<CR>', '[S]ave')

-- Remap tab and shift+tab for indenting
map('n', '<Tab>', ':><CR>', '[T]ab forward (4, Normal)')
map('n', '<S-Tab>', ':<<CR>', '[T]ab backward (4, Normal)')
map('x', '<Tab>', '>gv', '[T]ab forward (4, Visual)')
map('x', '<S-Tab>', '<gv', '[T]ab backward (4, Visual)')

-- Remap line delete to 'ctrl+x'
map('n', '<C-x>', 'dd', '[D]elete Line')
map('v', '<C-x>', 'D', '[D]elete Lines')

-- Search selected text with '/'
map('v', '/', function()
    vim.cmd 'normal! y'
    local escaped_text = vim.fn.escape(vim.fn.getreg '"', '/\\')
    vim.fn.setreg('/', '\\V' .. escaped_text)
    vim.cmd 'normal! n'
end, 'Search selected text')

-- [T]his [T]hing
-- wrap the first letter of word in brackets and capitalize it
map('n', '<leader>[[', function()
    utils.surround_and_capitalize()
end, 'Surround and [T]his [T]hing')

-- OIL (oil.nvim)
map('n', '<C-`>', function()
    require('oil').open()
end, 'OIL')

-- Obsidian
map('n', '<leader>oc', '<cmd>lua require("obsidian").util.toggle_checkbox()<CR>', '[O]bsidian toggle [c]heckbox')
map('n', '<leader>ot', '<cmd>ObsidianTemplate<CR>', 'Insert [O]bsidian [T]emplate')
map('n', '<leader>ob', '<cmd>ObsidianBacklinks<CR>', 'Show [O]bsidian [B]acklinks')
map('n', '<leader>oo', '<cmd>ObsidianOpen<CR>', '[O]pen in [O]bsidian App')
map('n', '<leader>os', '<cmd>ObsidianSearch<CR>', '[O]bsidian [S]earch')
map('n', '<leader>on', '<cmd>ObsidianNew<CR>', '[O]bsidian [N]ew Note')
map('n', '<leader>od', '<cmd>ObsidianDelete<CR>', '[O]bsidian [D]elete Note')
map('n', '<leader>op', '<cmd>ObsidianPreview<CR>', '[O]bsidian [P]review')
map('n', '<leader>oq', '<cmd>ObsidianQuickSwitch<CR>', '[O]bsidian [Q]uick Switch')
map('n', '<leader>ol', '<cmd>ObsidianLinks<CR>', '[O]bsidian Show [L]inks')

-- diffview (git diff)
map('n', '<leader>do', ':DiffviewOpen<CR>', '[D]iffview [O]pen')
map('n', '<leader>dc', ':DiffviewClose<CR>', '[D]iffview [C]lose')
map('n', '<leader>dh', ':DiffviewFileHistory<CR>', '[D]iffview File [H]istory')
map('n', '<leader>df', ':DiffviewToggleFiles<CR>', '[D]iffview Toggle [F]iles')

-- Toggle gitsigns
map('n', '<leader>gs', '<cmd>lua require("gitsigns").toggle_signs()<CR>', 'Toggle [G]it[S]igns')

-- Toggle Conceal and Spell (Markdown)
map('n', '<leader>md', function()
    utils.toggle_markdown_display()
end, 'Toggle [M]arkdown [D]isplay')
-- Run MarkdownPreview
map('n', '<leader>mp', '<cmd>MarkdownPreview<CR>', '[M]arkdown [P]review')
-- map('n', '<leader>mp', '<cmd>LivePreview<CR>', '[M]arkdown [P]review')

-- todo-comments.nvim and Trouble
map('n', '<leader>td', '<cmd>TodoTrouble<cr>', 'Show [T]odo [D]iagnostic Comments')
map('n', '<leader>tm', '<cmd>TodoQuickFix keywords=MINE<cr>', 'Show [M]y [T]odo Comments')
map('n', ']t', function()
    require('todo-comments').jump_next { keywords = { 'MINE' } }
end, 'Next `MINE` todo comment')
map('n', '[t', function()
    require('todo-comments').jump_prev { keywords = { 'MINE' } }
end, 'Previous `MINE` todo comment')

-- Harpoon
map('n', '<leader>a', function()
    harpoon:list():add()
end, '[A]dd [F]ile to Harpoon')
map('n', '<C-1>', function()
    harpoon:list():select(1)
end, '[S]elect Harpoon (1)')
map('n', '<C-2>', function()
    harpoon:list():select(2)
end, '[S]elect Harpoon (2)')
map('n', '<C-3>', function()
    harpoon:list():select(3)
end, '[S]elect Harpoon (3)')
map('n', '<C-4>', function()
    harpoon:list():select(4)
end, '[S]elect Harpoon (4)')

-- nvim-tree
map('n', '<leader>E', '<cmd>NvimTreeToggle<CR>', 'Explorer [N]vimTree')

-- tiny-code-action
map('n', '<leader>ct', function()
    require('tiny-code-action').code_action()
end, 'Code [A]ction (Tiny)')

-- Bufferline
map('n', '<C-w>', "<cmd>lua require('bufdelete').bufdelete()<CR>", '[D]elete Buffer (Tab)')
map('n', '<leader>co', '<cmd>BufferLineCloseOthers<CR>', '[C]lose all [O]ther open tabs')
map('n', '<leader>cl', '<cmd>BufferLineCloseLeft<CR>', '[C]lose open tabs to the [L]eft')
map('n', '<leader>cr', '<cmd>BufferLineCloseRight<CR>', '[C]lose open tabs to the [R]ight')
map('n', '<leader>bp', '<cmd>BufferLineTogglePin<CR>', 'Toggle [B]uffer [P]in')
map('n', '-', '<cmd>BufferLineCyclePrev<CR>', 'Cycle buffers Prev (Left)')
map('n', '=', '<cmd>BufferLineCycleNext<CR>', 'Cycle buffers Next (Right)')
map('n', '<C-->', '<cmd>BufferLineMovePrev<CR>', 'Move buffer Left')
map('n', '<C-=>', '<cmd>BufferLineMoveNext<CR>', 'Move buffer Right')
for i = 1, 9 do
    map('n', '<leader>' .. i, '<cmd>BufferLineGoToBuffer ' .. i .. '<CR>', 'Go to buffer ' .. i)
end

-- Split creation/navigation
map('n', '<C-j>', '<C-w>k', 'Move focus to the split above')
map('n', '<C-k>', '<C-w>j', 'Move focus to the split below')
map('n', '<C-S-j>', '<C-w>h', 'Move focus to the split on the left')
map('n', '<C-S-k>', '<C-w>l', 'Move focus to the split on the right')
--
-- Workaround for `<A-j>`, `<A-k>`, `<A-h>`, `<A-l>` not working in kitty for some reason
vim.api.nvim_set_keymap('n', '˚', '<C-w>J', { noremap = true, desc = 'Move split up' }) -- Alt+j
vim.api.nvim_set_keymap('n', '∆', '<C-w>K', { noremap = true, desc = 'Move split down' }) -- Alt+k
vim.api.nvim_set_keymap('n', '˙', '<C-w>H', { noremap = true, desc = 'Move split left' }) -- Alt+h
vim.api.nvim_set_keymap('n', '¬', '<C-w>L', { noremap = true, desc = 'Move split right' }) -- Alt+l
map('n', '<C-,>', function()
    utils.scale_split '-1'
end, 'Scale the current split by -1')
map('n', '<C-.>', function()
    utils.scale_split '+1'
end, 'Scale the current split by +1')
map('n', '<leader>vs', ':vsplit<CR>', 'Vertical split')
map('n', '<leader>hs', ':split<CR>', 'Horizontal split')
map('n', '<leader>dd', '<C-w>c', 'Close split')

-- Xcodebuild / sourcekit-lsp
map('n', '<leader>X', '<cmd>XcodebuildPicker<cr>', 'Show Xcodebuild Actions')
map('n', '<leader>xf', '<cmd>XcodebuildProjectManager<cr>', 'Show Project Manager Actions')
map('n', '<leader>xb', '<cmd>XcodebuildBuild<cr>', 'Build Project')
map('n', '<leader>xB', '<cmd>XcodebuildBuildForTesting<cr>', 'Build For Testing')
map('n', '<leader>xr', '<cmd>XcodebuildBuildRun<cr>', 'Build & Run Project')
map('n', '<leader>xt', '<cmd>XcodebuildTest<cr>', 'Run Tests')
map('v', '<leader>xt', '<cmd>XcodebuildTestSelected<cr>', 'Run Selected Tests')
map('n', '<leader>xT', '<cmd>XcodebuildTestClass<cr>', 'Run This Test Class')
map('n', '<leader>xl', '<cmd>XcodebuildToggleLogs<cr>', 'Toggle Xcodebuild Logs')
map('n', '<leader>xc', '<cmd>XcodebuildToggleCodeCoverage<cr>', 'Toggle Code Coverage')
map('n', '<leader>xC', '<cmd>XcodebuildShowCodeCoverageReport<cr>', 'Show Code Coverage Report')
map('n', '<leader>xe', '<cmd>XcodebuildTestExplorerToggle<cr>', 'Toggle Test Explorer')
map('n', '<leader>xs', '<cmd>XcodebuildFailingSnapshots<cr>', 'Show Failing Snapshots')
map('n', '<leader>xd', '<cmd>XcodebuildSelectDevice<cr>', 'Select Device')
map('n', '<leader>xp', '<cmd>XcodebuildSelectTestPlan<cr>', 'Select Test Plan')
map('n', '<leader>xq', '<cmd>Telescope quickfix<cr>', 'Show QuickFix List')
map('n', '<leader>xx', '<cmd>XcodebuildQuickfixLine<cr>', 'Quickfix Line')
map('n', '<leader>xa', '<cmd>XcodebuildCodeActions<cr>', 'Show Code Actions')

-- ncks.nvim
map('n', '<leader>nn', '<cmd>NcksNew<cr>', 'Add [N]ew [N]ickname')
map('n', '<leader>no', '<cmd>NcksOpen<cr>', '[O]pen [N]cks file')
map('n', '<leader>nl', '<cmd>NcksList<cr>', '[L]ist [N]cks files')
map('n', '<leader>ns', '<cmd>NcksSearch<cr>', 'Search [N]cks file')
map('n', '<leader>nr', '<cmd>NcksRandom<cr>', 'Pick [R]andom [N]ick from file')
map('n', '<leader>nc', '<cmd>NcksCopyAll<cr>', '[C]opy all [N]icknames from file to clipboard')
map('n', '<leader>ni', '<cmd>NcksInfo<cr>', 'Show [N]icks file [I]nfo')

-- Spectre
map('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', '[S]pectre Toggle')

-- Map left/right subword navigation to ctrl+left / ctrl+right
map('n', '<C-Left>', 'b', 'Subword navigate left')
map('n', '<C-Right>', 'w', 'Subword navigate right')
map('i', '<C-Left>', '<C-o>b', 'Subword navigate left (insert mode)')
map('i', '<C-Right>', '<C-o>w', 'Subword navigate right (insert mode)')

-- Source the Neovim configuration file
map('n', '<leader>rr', ':luafile $HOME/dotfiles/nvim/init.lua<CR>', 'Reload Neovim configuration')

-- Write Quit
map('n', '<leader>wq', function()
    vim.cmd 'wq'
end, '[W]rite and [Q]uit')
map('n', '<leader>qq', function()
    vim.cmd 'qa'
end, '[Q]uit All')

-- Undo/Redo: 'u' >> 'ctrl+z', 'ctrl+r' >> 'shift+ctrl+z'
map('n', '<C-Z>', ':undo<CR>', 'Undo (Normal)')
map('i', '<C-Z>', '<ESC>:undo<CR>a', 'Undo (Insert)')
map('n', 'r', ':redo<CR>', 'Redo (Normal)')
map('n', '<S-C-Z>', ':redo<CR>', 'Redo (Normal)')
map('i', '<S-C-Z>', '<ESC>:redo<CR>', 'Redo (Insert)')
map('n', '<leader>u', '<cmd>Telescope undo<cr>', 'Undo (Telescope)')

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, 'Go to previous [D]iagnostic message')
map('n', '<leader>q', vim.diagnostic.setloclist, 'Open diagnostic [Q]uickfix list')

-- YankBank
map('n', '<leader>y', '<cmd>YankBank<CR>', 'Open YankBank popup')

-- Cheatsheet
map('n', '<leader>ch', '<cmd>:Cheatsheet<CR>', 'Show [C][h]eatsheet')

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', 'Exit terminal mode')

-- Tabs
for i = 1, 9 do
    map('n', '`' .. i, '<cmd>tabn ' .. i .. '<cr>', 'Go to tab ' .. i)
end

map('n', '`t', '<cmd>tabnew<cr>', 'New Tab')
map('n', '`w', '<cmd>tabclose<cr>', 'Close Tab')

map('n', '<S-Down>', function()
    utils.scroll_less_screen 'down'
end, '[M]ove screen [D]own')

map('n', '<S-Up>', function()
    utils.scroll_less_screen 'up'
end, '[M]ove screen [U]p')

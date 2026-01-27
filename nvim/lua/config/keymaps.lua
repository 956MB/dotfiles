local utils = require 'config.utils'

local function map(mode, lhs, rhs, desc, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    opts.desc = desc
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

map('n', 'q', '<Nop>', 'Disable q in normal mode')

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

-- ufo fold stuff
map('n', 'zR', function()
    require('ufo').openAllFolds()
end, 'openAllFolds')
map('n', 'zM', function()
    require('ufo').closeAllFolds()
end, 'closeAllFolds')
map('n', 'K', function()
    local winid = require('ufo').peekFoldedLinesUnderCursor()
    if not winid then
        vim.lsp.buf.hover()
    end
end)

-- Create new lines above and below without moving the cursor
map('n', '<leader>io', function()
    local current_line = vim.fn.line '.'
    vim.api.nvim_buf_set_lines(0, current_line - 1, current_line - 1, false, { '' })
    vim.api.nvim_buf_set_lines(0, current_line + 1, current_line + 1, false, { '' })
end, 'New lines above and below (stay)')

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
map('i', '<C-s>', '<ESC>:noa w<CR>', '[S]ave')
map('n', '<C-s>', ':noa w<CR>', '[S]ave')

-- Remap tab and shift+tab for indenting
map('n', '<Tab>', ':><CR>', '[T]ab forward (4, Normal)')
map('n', '<S-Tab>', ':<<CR>', '[T]ab backward (4, Normal)')
map('x', '<Tab>', '>gv', '[T]ab forward (4, Visual)')
map('x', '<S-Tab>', '<gv', '[T]ab backward (4, Visual)')

-- Remap line delete to 'ctrl+x'
map('n', '<C-x>', 'dd', '[D]elete Line')
map('v', '<C-x>', 'D', '[D]elete Lines')

-- Move view up/down/center
map('n', '<C-m>', function()
    local current_line = vim.fn.line '.'
    local window_height = vim.fn.winheight(0)
    local target_topline = current_line - math.floor(window_height / 2)
    target_topline = math.max(1, target_topline)

    vim.fn.winrestview { topline = target_topline }
end, 'Center view without moving cursor')
map('n', '<S-C-Up>', function()
    local topline = vim.fn.winsaveview().topline
    vim.fn.winrestview { topline = math.max(1, topline - 5) }
end, 'Move view up slightly')
map('n', '<S-C-Down>', function()
    local topline = vim.fn.winsaveview().topline
    local total_lines = vim.fn.line '$'
    local window_height = vim.fn.winheight(0)
    vim.fn.winrestview { topline = math.min(total_lines - window_height + 1, topline + 5) }
end, 'Move view down slightly')

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
if vim.fn.has 'win32' == 1 or vim.fn.has 'wsl' == 1 then
    map('n', '<C-e>', function()
        require('oil').open()
    end, 'OIL')
else
    map('n', '<C-`>', function()
        require('oil').open()
    end, 'OIL')
end

map('n', '<leader>yh', function()
    require('yazi').toggle()
end, 'Open Yazi file explorer in horizonal split')

-- Overseer (run tasks)
map('n', '<leader>ot', '<cmd>OverseerToggle<CR>', '[T]asks [O]pen/close')
map('n', '<C-S-t>', '<cmd>OverseerRun<CR>', '[T]ask [R]un')
map('n', '<C-S-r>', '<cmd>OverseerQuickAction restart<CR>', '[T]ask [R]erun last')
map('n', '<leader>ol', '<cmd>OverseerLoadBundle<CR>', '[T]ask [L]oad bundle')
map('n', '<leader>os', '<cmd>OverseerSaveBundle<CR>', '[T]ask [S]ave bundle')
map('n', '<leader>oa', '<cmd>OverseerTaskAction<CR>', '[T]ask [A]ction')
map('n', '<leader>ob', '<cmd>OverseerBuild<CR>', '[T]ask [B]uild new')
map('n', '<leader>oc', '<cmd>OverseerClearCache<CR>', '[T]ask [C]lear cache')

-- vgit
-- map('n', '<C-k>', function()
--     require('vgit').hunk_up()
-- end, 'Navigate to previous hunk')
-- map('n', '<C-j>', function()
--     require('vgit').hunk_down()
-- end, 'Navigate to next hunk')
map('n', '<leader>gs', function()
    require('vgit').buffer_hunk_stage()
end, 'Stage current hunk')
map('n', '<leader>gr', function()
    require('vgit').buffer_hunk_reset()
end, 'Reset current hunk')
map('n', '<leader>gp', function()
    require('vgit').buffer_hunk_preview()
end, 'Preview hunk changes')
map('n', '<leader>gb', function()
    require('vgit').buffer_blame_preview()
end, 'Show git blame')
map('n', '<leader>gf', function()
    require('vgit').buffer_diff_preview()
end, 'Show buffer diff')
map('n', '<leader>gh', function()
    require('vgit').buffer_history_preview()
end, 'Show commit history')
map('n', '<leader>gu', function()
    require('vgit').buffer_reset()
end, 'Reset buffer to HEAD')
map('n', '<leader>gd', function()
    require('vgit').project_diff_preview()
end, 'Show project diff')
map('n', '<leader>gx', function()
    require('vgit').toggle_diff_preference()
end, 'Toggle diff display mode')

map('n', '<leader>gs', function()
    local buf = vim.api.nvim_get_current_buf()
    local current = vim.b[buf].gitsigns_disable or false
    vim.b[buf].gitsigns_disable = not current
    require('gitsigns').refresh()
end, 'Toggle [G]it[S]igns')

-- Toggle gitsigns
-- map('n', '<leader>gs', '<cmd>lua require("gitsigns").toggle_signs()<CR>', 'Toggle [G]it[S]igns')

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

-- nvim-tree
map('n', '<leader>E', '<cmd>NvimTreeToggle<CR>', 'Explorer [N]vimTree')

-- tiny-code-action
map('n', '<leader>ct', function()
    require('tiny-code-action').code_action {}
end, 'Code [A]ction (Tiny)')

-- Bufferline
map('n', '<C-w>', "<cmd>lua require('bufdelete').bufdelete()<CR>", '[D]elete Buffer (Tab)')
map('n', '<leader>co', '<cmd>BufferLineCloseOthers<CR>', '[C]lose all [O]ther open tabs')
map('n', '<leader>cl', '<cmd>BufferLineCloseLeft<CR>', '[C]lose open tabs to the [L]eft')
map('n', '<leader>cr', '<cmd>BufferLineCloseRight<CR>', '[C]lose open tabs to the [R]ight')
map('n', '<leader>bp', '<cmd>BufferLineTogglePin<CR>', 'Toggle [B]uffer [P]in')
map('n', '-', '<cmd>BufferLineCyclePrev<CR>', 'Cycle buffers Prev (Left)')
map('n', '=', '<cmd>BufferLineCycleNext<CR>', 'Cycle buffers Next (Right)')
map('n', '<C-S-->', '<cmd>BufferLineMovePrev<CR>', 'Move buffer Left')
map('n', '<C-S-=>', '<cmd>BufferLineMoveNext<CR>', 'Move buffer Right')
for i = 1, 9 do
    map('n', '<leader>' .. i, '<cmd>BufferLineGoToBuffer ' .. i .. '<CR>', 'Go to buffer ' .. i)
end

-- Split creation/navigation
map('n', '<C-,>', function()
    require('smart-splits').resize_left()
end, 'Resize split left')
map('n', '<C-S-.>', function()
    require('smart-splits').resize_down()
end, 'Resize split down')
map('n', '<C-S-,>', function()
    require('smart-splits').resize_up()
end, 'Resize split up')
map('n', '<C-.>', function()
    require('smart-splits').resize_right()
end, 'Resize split right')
map('n', '<C-j>', function()
    require('smart-splits').move_cursor_left()
end, 'Move to left split')
map('n', '<C-S-k>', function()
    require('smart-splits').move_cursor_down()
end, 'Move to down split')
map('n', '<C-S-j>', function()
    require('smart-splits').move_cursor_up()
end, 'Move to up split')
map('n', '<C-k>', function()
    require('smart-splits').move_cursor_right()
end, 'Move to right split')
map('n', '<C-\\>', function()
    require('smart-splits').move_cursor_previous()
end, 'Move to previous split')
map('n', '<leader><leader>h', function()
    require('smart-splits').swap_buf_left()
end, 'Swap buffer left')
map('n', '<leader><leader>j', function()
    require('smart-splits').swap_buf_down()
end, 'Swap buffer down')
map('n', '<leader><leader>k', function()
    require('smart-splits').swap_buf_up()
end, 'Swap buffer up')
map('n', '<leader><leader>l', function()
    require('smart-splits').swap_buf_right()
end, 'Swap buffer right')
map('n', '<leader>vs', ':vsplit<CR>', 'Vertical split')
map('n', '<leader>hs', ':split<CR>', 'Horizontal split')
map('n', '<leader>dd', '<C-w>c', 'Close split')

-- Xcodebuild / sourcekit-lsp
-- map('n', '<leader>X', '<cmd>XcodebuildPicker<cr>', 'Show Xcodebuild Actions')
-- map('n', '<leader>xf', '<cmd>XcodebuildProjectManager<cr>', 'Show Project Manager Actions')
-- map('n', '<leader>xb', '<cmd>XcodebuildBuild<cr>', 'Build Project')
-- map('n', '<leader>xB', '<cmd>XcodebuildBuildForTesting<cr>', 'Build For Testing')
-- map('n', '<leader>xr', '<cmd>XcodebuildBuildRun<cr>', 'Build & Run Project')
-- map('n', '<leader>xt', '<cmd>XcodebuildTest<cr>', 'Run Tests')
-- map('v', '<leader>xt', '<cmd>XcodebuildTestSelected<cr>', 'Run Selected Tests')
-- map('n', '<leader>xT', '<cmd>XcodebuildTestClass<cr>', 'Run This Test Class')
-- map('n', '<leader>xl', '<cmd>XcodebuildToggleLogs<cr>', 'Toggle Xcodebuild Logs')
-- map('n', '<leader>xc', '<cmd>XcodebuildToggleCodeCoverage<cr>', 'Toggle Code Coverage')
-- map('n', '<leader>xC', '<cmd>XcodebuildShowCodeCoverageReport<cr>', 'Show Code Coverage Report')
-- map('n', '<leader>xe', '<cmd>XcodebuildTestExplorerToggle<cr>', 'Toggle Test Explorer')
-- map('n', '<leader>xs', '<cmd>XcodebuildFailingSnapshots<cr>', 'Show Failing Snapshots')
-- map('n', '<leader>xd', '<cmd>XcodebuildSelectDevice<cr>', 'Select Device')
-- map('n', '<leader>xp', '<cmd>XcodebuildSelectTestPlan<cr>', 'Select Test Plan')
-- map('n', '<leader>xq', '<cmd>Telescope quickfix<cr>', 'Show QuickFix List')
-- map('n', '<leader>xx', '<cmd>XcodebuildQuickfixLine<cr>', 'Quickfix Line')
-- map('n', '<leader>xa', '<cmd>XcodebuildCodeActions<cr>', 'Show Code Actions')

-- ncks.nvim
map('n', '<leader>nn', '<cmd>NcksNew<cr>', 'Add [N]ew [N]ickname')
map('n', '<leader>no', '<cmd>NcksOpen<cr>', '[O]pen [N]cks file')
map('n', '<leader>nl', '<cmd>NcksList<cr>', '[L]ist [N]cks files')
map('n', '<leader>ns', '<cmd>NcksSearch<cr>', 'Search [N]cks file')
map('n', '<leader>nr', '<cmd>NcksRandom<cr>', 'Pick [R]andom [N]ick from file')
map('n', '<leader>nc', '<cmd>NcksCopyAll<cr>', '[C]opy all [N]icknames from file to clipboard')
map('n', '<leader>ni', '<cmd>NcksInfo<cr>', 'Show [N]icks file [I]nfo')

-- GrugFar search and replace
map('n', '<leader>S', '<cmd>:GrugFar<CR>', '[S]pectre Toggle')

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
map('n', ']d', vim.diagnostic.goto_next, 'Go to next [D]iagnostic message')
map('n', '[l', function()
    vim.diagnostic.goto_prev { float = false }
end, 'Go to previous diagnostic location (no popup)')
map('n', ']l', function()
    vim.diagnostic.goto_next { float = false }
end, 'Go to next diagnostic location (no popup)')
-- map('n', '<leader>q', vim.diagnostic.setloclist, 'Open diagnostic [Q]uickfix list')

-- YankBank
map('n', '<leader>y', '<cmd>YankBank<CR>', 'Open YankBank popup')

-- Cheatsheet
map('n', '<leader>ch', '<cmd>:Cheatsheet<CR>', 'Show [C][h]eatsheet')

-- NOTE: This won't work in all terminal emulators/tmux/etc.
map('t', '<Esc><Esc>', '<C-\\><C-n>', 'Exit terminal mode')

-- Tabs
for i = 1, 9 do
    map('n', '`' .. i, '<cmd>tabn ' .. i .. '<cr>', 'Go to tab ' .. i)
end

map('n', '`t', '<cmd>tabnew<cr>', 'New Tab')
map('n', '`w', '<cmd>tabclose<cr>', 'Close Tab')

map('n', '<S-C-Down>', function()
    utils.scroll_less_screen 'down'
end, '[M]ove screen [D]own')

map('n', '<S-C-Up>', function()
    utils.scroll_less_screen 'up'
end, '[M]ove screen [U]p')

-- Zed nvim style shift+selection
map('n', '<S-Down>', 'vj', 'Start visual selection down')
map('n', '<S-Up>', 'vk', 'Start visual selection up')
map('v', '<S-Down>', 'j', 'Extend selection down')
map('v', '<S-Up>', 'k', 'Extend selection up')
map('i', '<S-Down>', '<C-o>vj', 'Start visual selection down (insert mode)')
map('i', '<S-Up>', '<C-o>vk', 'Start visual selection up (insert mode)')

-- opencode.nvim keymaps
map({ 'n', 'x' }, '<C-S-a>', function()
    require('opencode').ask('@this: ', { submit = true })
end, 'Ask opencode…')
map({ 'n', 'x' }, '<C-S-o>', function()
    require('opencode').select()
end, 'Execute opencode action…')
map({ 'n', 't' }, '<C-/>', function()
    local current_win = vim.api.nvim_get_current_win()
    require('opencode').toggle()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local bufname = vim.api.nvim_buf_get_name(buf)
        if bufname:match 'opencode' then
            vim.api.nvim_set_current_win(win)
            return
        end
    end
    if vim.api.nvim_win_is_valid(current_win) then
        vim.api.nvim_set_current_win(current_win)
    end
end, 'Toggle opencode')
map({ 'n', 'x' }, 'go', function()
    return require('opencode').operator '@this '
end, 'Add range to opencode', { expr = true })
map('n', 'goo', function()
    return require('opencode').operator '@this ' .. '_'
end, 'Add line to opencode', { expr = true })
map({ 'n', 't' }, '<C-S-u>', function()
    require('opencode').command 'session.half.page.up'
end, 'Scroll opencode half page up')
map({ 'n', 't' }, '<C-S-d>', function()
    require('opencode').command 'session.half.page.down'
end, 'Scroll opencode half page down')
map({ 'n', 't' }, '<C-S-l>', function()
    require('opencode').command 'session.line.up'
end, 'Scroll opencode line up')
map({ 'n', 't' }, '<C-S-;>', function()
    require('opencode').command 'session.line.down'
end, 'Scroll opencode line down')
map({ 'n', 't' }, '<C-S-p>', function()
    require('opencode').command 'session.page.up'
end, 'Scroll opencode page up')
map({ 'n', 't' }, '<C-S-n>', function()
    require('opencode').command 'session.page.down'
end, 'Scroll opencode page down')
map({ 'n', 't' }, '<C-S-h>', function()
    require('opencode').command 'session.first'
end, 'Scroll opencode to first')
map({ 'n', 't' }, '<C-S-g>', function()
    require('opencode').command 'session.last'
end, 'Scroll opencode to last')
-- map('n', '+', '<C-a>', 'Increment under cursor', { noremap = true })
-- map('n', '-', '<C-x>', 'Decrement under cursor', { noremap = true })

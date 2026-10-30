-- [[ fff.nvim — replaces telescope.nvim ]]
-- Keys deliberately mirror the old telescope mappings so muscle memory carries over.
-- fff covers file + content search. The pickers fff has no equivalent for
-- (help, keymaps, diagnostics, buffers, recent, resume, LSP symbols) fall back to
-- Snacks.picker, which is already a dependency.
-- The old telescope setup is kept untouched in plugins/telescope.lua; re-enable it
-- by uncommenting `require 'plugins.telescope'` in config/pack.lua.
--
-- File filtering: fff honours .gitignore. Add a `.ignore` file for picker-only
-- excludes (replaces telescope's file_ignore_patterns: node_modules, target, vendor).

-- From the README's vim.pack recipe. Set debug.enabled = false to drop the score overlay.
vim.g.fff = {
    lazy_sync = true,
    debug = { enabled = true, show_scores = true },
}

local fff = require 'fff'

-- Layout mirrors telescope's main_layout preset from plugins/telescope.lua
require('fff').setup {
    prompt = '   ',
    max_results = 100,
    wrap_around = true,
    layout = {
        width = 0.87,
        height = 0.60,
        prompt_position = 'top',
        preview_position = 'right',
        preview_size = 0.55,
    },
}

local map = vim.keymap.set
-- stylua: ignore start

-- fff-native pickers, same keys as the telescope mappings they replace
map({ 'n', 'v' }, '<C-p>', function()
    fff.find_files()
end, { desc = '[S]earch [F]iles (fff)', silent = true })
map({ 'n', 'v' }, '<C-g>', function()
    fff.live_grep()
end, { desc = '[S]earch by [G]rep (fff)', silent = true })
map({ 'n', 'v' }, '<leader>sw', function()
    fff.live_grep_under_cursor()
end, { desc = '[S]earch current [W]ord (fff)', silent = true })
map({ 'n', 'v' }, '<leader>sn', function()
    fff.find_files_in_dir(vim.fn.stdpath 'config')
end, { desc = '[S]earch [N]eovim files (fff)', silent = true })

-- README default keys, kept alongside the telescope-style ones
map('n', 'ff', function()
    fff.find_files()
end, { desc = '[F]ind [F]iles (fff)', silent = true })
map('n', 'fg', function()
    fff.live_grep()
end, { desc = '[L]iFFFe [G]rep', silent = true })
map('n', 'fz', function()
    fff.live_grep { grep = { modes = { 'fuzzy', 'plain' } } }
end, { desc = 'Live fffu[Z]y grep', silent = true })
map({ 'n', 'x' }, 'fw', function()
    fff.live_grep_under_cursor()
end, { desc = 'Search current word / selection (fff)', silent = true })

-- Pickers fff does not provide -> Snacks.picker
local function open_files()
    local files = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local name = vim.api.nvim_buf_get_name(buf)
        if name ~= '' and vim.bo[buf].buftype == '' then
            files[#files + 1] = name
        end
    end
    return files
end

map({ 'n', 'v' }, '<leader>sh', function()
    Snacks.picker.help()
end, { desc = '[S]earch [H]elp' })
map({ 'n', 'v' }, '<leader>sk', function()
    Snacks.picker.keymaps()
end, { desc = '[S]earch [K]eymaps' })
map({ 'n', 'v' }, '<leader>ss', function()
    Snacks.picker.smart()
end, { desc = '[S]earch [S]elect (was Telescope builtin)' })
map({ 'n', 'v' }, '<leader>sd', function()
    Snacks.picker.diagnostics()
end, { desc = '[S]earch [D]iagnostics' })
map({ 'n', 'v' }, '<leader>sr', function()
    Snacks.picker.resume()
end, { desc = '[S]earch [R]esume' })
map({ 'n', 'v' }, '<leader>s.', function()
    Snacks.picker.recent()
end, { desc = '[S]earch Recent Files ("." for repeat)' })
map({ 'n', 'v' }, '<leader>?', function()
    Snacks.picker.recent()
end, { desc = '[?] Find recently opened files' })
map({ 'n', 'v' }, '<C-t>', function()
    Snacks.picker.buffers()
end, { desc = '[S]earch [T]abs (Buffers)' })
map({ 'n', 'v' }, '<leader><space>', function()
    Snacks.picker.buffers()
end, { desc = '[ ] Find existing buffers' })
map({ 'n', 'v' }, '<leader>s/', function()
    Snacks.picker.grep { paths = open_files() }
end, { desc = '[S]earch [/] in Open Files' })
map({ 'n', 'v' }, '<C-f>', function()
    Snacks.picker.grep { paths = { vim.api.nvim_buf_get_name(0) } }
end, { desc = 'Fuzzy find in current buffer' })

-- stylua: ignore end

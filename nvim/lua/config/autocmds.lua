-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Set the filetype of .db files to sqlite (prisma)
vim.cmd [[autocmd BufRead,BufNewFile *.db set filetype=sqlite]]

-- Force none relative line numbers
vim.cmd [[
    augroup DisableRelativeNumber
        autocmd!
        autocmd BufEnter * :set norelativenumber
    augroup END
]]

-- Turn off spell when opening markdown files
vim.cmd [[
    autocmd FileType markdown setlocal nospell
]]

-- Reload Neovim config when changes are made to the lua directory
local config_path = vim.env.LAZYVIM_CONFIG_PATH or vim.fn.stdpath 'config'

vim.api.nvim_create_augroup('ReloadConfig', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
    group = 'ReloadConfig',
    pattern = config_path .. '/**/*', -- Watch for changes in any file under the config directory
    command = 'source ' .. config_path .. '/init.lua', -- Reload the init.lua file
})

function SetWindowPadding()
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(win)
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })
    local filetype = vim.api.nvim_get_option_value('filetype', { buf = buf })

    local is_toggleterm = false
    pcall(function()
        is_toggleterm = vim.api.nvim_buf_get_var(buf, 'toggle_number') ~= nil
    end)
    -- If the above check failed, try an alternative method
    if not is_toggleterm then
        is_toggleterm = filetype == 'toggleterm'
    end

    -- Only apply padding to normal buffers and nvim-tree
    if (buftype == '' or filetype == 'NvimTree') and not is_toggleterm then
        local width = vim.api.nvim_win_get_width(win)
        if width > 1 then
            vim.api.nvim_set_option_value('winbar', string.rep(' ', width), { win = win })
        end
    else
        vim.api.nvim_set_option_value('winbar', nil, { win = win })
    end
end

-- Apply padding when entering a window
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter' }, {
    callback = SetWindowPadding,
})

-- golings file save/watch nonsense work around
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.go',
    callback = function()
        local file = vim.fn.expand '<afile>:p'
        local is_exercise = string.match(file, 'exercises/.+/main%.go$')
        local golings_in_path = vim.fn.executable 'golings' == 1

        if golings_in_path or is_exercise then
            -- Disable the 'writebackup' option temporarily
            local old_writebackup = vim.o.writebackup
            vim.o.writebackup = false

            vim.cmd 'write!'
            vim.o.writebackup = old_writebackup
            vim.cmd 'edit!'
        end
    end,
})

-- Function to load local config
local function load_local_config()
    local local_config = vim.fn.getcwd() .. '/.nvim.lua'
    if vim.fn.filereadable(local_config) == 1 then
        dofile(local_config)
    end
end

-- Create an autocommand to load the local config after changing directories
vim.api.nvim_create_autocmd({ 'DirChanged' }, {
    pattern = '*',
    callback = load_local_config,
})

-- Load local config on startup
load_local_config()

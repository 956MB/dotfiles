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
    local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
    local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')

    -- Only apply padding to normal buffers and nvim-tree
    if buftype == '' or filetype == 'NvimTree' then
        local width = vim.api.nvim_win_get_width(win)
        if width > 1 then
            vim.api.nvim_win_set_option(win, 'winbar', string.rep(' ', width))
        end
    else
        vim.api.nvim_win_set_option(win, 'winbar', nil)
    end
end

-- Apply padding when entering a window
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter' }, {
    callback = SetWindowPadding,
})

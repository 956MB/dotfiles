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

-- Set tab settings for all files
-- vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
--     pattern = '*',
--     callback = function()
--         vim.opt.tabstop = 4
--         vim.opt.softtabstop = 4
--         vim.opt.shiftwidth = 4
--         vim.opt.expandtab = true
--     end,
-- })

-- Reload Neovim config when changes are made to the lua directory
local config_path = vim.env.LAZYVIM_CONFIG_PATH or vim.fn.stdpath 'config'

vim.api.nvim_create_augroup('ReloadConfig', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
    group = 'ReloadConfig',
    pattern = config_path .. '/**/*', -- Watch for changes in any file under the config directory
    command = 'source ' .. config_path .. '/init.lua', -- Reload the init.lua file
})

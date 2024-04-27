-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info

local fork = true
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if fork then
    lazypath = vim.fn.stdpath 'config' .. '/lua/plugins/custom/lazy.nvim'
else
    if not vim.loop.fs_stat(lazypath) then
        local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
        vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    end ---@diagnostic disable-next-line: undefined-field
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
    spec = {
        { 'LazyVim/LazyVim', import = 'lazyvim.plugins' },
        { import = 'plugins' },
        -- dir = '~/dotfiles/nvim/lua/plugins/custom/ncks.nvim',
    },
    ui = {
        urls = {
            enabled = true, -- show URLs on home page by default
            front = '-- ',
            back = '',
        },
    },
    defaults = {
        lazy = false,
        version = false, -- always use the latest git commit
    },
    install = { colorscheme = { 'github_dark' } }, -- habamax, oxocarbon, github_dark_colorblind
    checker = { enabled = false }, -- automatically check for plugin updates
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

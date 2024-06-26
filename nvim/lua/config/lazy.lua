-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info

local fork = true
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if fork then
    lazypath = vim.fn.stdpath 'config' .. '/lua/plugins/custom/lazy.nvim'
else
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        vim.fn.system {
            'git',
            'clone',
            '--filter=blob:none',
            'https://github.com/956MB/lazy.nvim.git',
            '--branch=summary-urls',
            lazypath,
        }
    end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
    spec = {
        { 'LazyVim/LazyVim', import = 'lazyvim.plugins' },
        { import = 'plugins' },
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
    -- habamax
    -- oxocarbon
    -- github_dark_colorblind
    -- gruvbox-baby
    -- base16-default-dark
    -- gruber-darker
    -- poimandres
    -- sobrio
    install = { colorscheme = { 'sobrio' } },
    checker = { enabled = false }, -- automatically check for plugin updates
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

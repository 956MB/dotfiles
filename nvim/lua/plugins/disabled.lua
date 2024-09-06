local is_neovide = vim.g.neovide or false

return {
    -- Disabled plugins

    { 'nvimdev/dashboard-nvim', optional = true, enabled = false },
    { 'echasnovski/mini.starter', optional = true, enabled = false },
    { 'catppuccin/nvim', enabled = false },
    { 'folke/tokyonight.nvim', enabled = false },
    { 'Rics-Dev/project-explorer.nvim', enabled = is_neovide },
}

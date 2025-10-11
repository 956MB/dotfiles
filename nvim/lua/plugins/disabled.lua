local is_neovide = vim.g.neovide or false

return {
    -- Disabled plugins

    { 'folke/neodev.nvim', enabled = false },
    { 'nvimdev/dashboard-nvim', optional = true, enabled = false },
    { 'nvim-mini/mini.starter', optional = true, enabled = false },
    { 'catppuccin', enabled = false },
    { 'folke/tokyonight.nvim', enabled = false },
    { 'Rics-Dev/project-explorer.nvim', enabled = is_neovide },
    { 'nvim-neo-tree/neo-tree.nvim', enabled = false },
    { 'nvim-tree/nvim-web-devicons', enabled = false },
    { 'nvim-mini/mini.icons', enabled = false },
}

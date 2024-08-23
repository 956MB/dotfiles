local is_neovide = vim.g.neovide or false

return {
    -- Disabled plugins

    { 'catppuccin/nvim', enabled = false },
    { 'folke/tokyonight.nvim', enabled = false },
    { 'Rics-Dev/project-explorer.nvim', enabled = is_neovide },
}

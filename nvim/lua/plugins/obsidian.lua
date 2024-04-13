return {
    {
        'epwalsh/obsidian.nvim',
        version = '*',
        lazy = true,
        ft = 'markdown',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
        },
        opts = {
            workspaces = {
                {
                    name = 'ObsidianVault',
                    path = '~/Documents/Obsidian Vault',
                },
            },
            mappings = {},
        },
    },
}

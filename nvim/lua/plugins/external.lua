return {
    -- { -- Markdown live preview
    --     'iamcco/markdown-preview.nvim',
    --     cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    --     ft = { 'markdown' },
    --     build = function()
    --         vim.fn['mkdp#util#install']()
    --     end,
    -- },

    {
        'brianhuster/live-preview.nvim',
        config = function()
            require('live-preview').setup {
                commands = {
                    start = 'LivePreview',
                    stop = 'StopPreview',
                },
                port = 5500,
                browser = 'default',
            }
        end,
    },

    { -- Obsidian integration
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

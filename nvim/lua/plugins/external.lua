return {
    { -- Markdown live preview
        'iamcco/markdown-preview.nvim',
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        ft = { 'markdown' },
        build = function()
            vim.fn['mkdp#util#install']()
        end,
    },

    -- { -- Markdown live preview (different)
    --     'brianhuster/live-preview.nvim',
    --     config = function()
    --         require('live-preview').setup()
    --     end,
    -- },

    { -- Obsidian integration
        'epwalsh/obsidian.nvim',
        version = '*',
        lazy = true,
        ft = 'markdown',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
        },
        opts = function()
            local is_mac = vim.loop.os_uname().sysname == 'Darwin'

            return {
                workspaces = {
                    {
                        name = 'ObsidianVault',
                        path = is_mac and '~/Documents/Obsidian Vault' or '/mnt/c/Users/infga/Documents/All',
                    },
                },
                mappings = {},
            }
        end,
    },
}

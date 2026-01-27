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
    --

    { -- Task runner
        'stevearc/overseer.nvim',
        config = function()
            vim.o.shell = '/bin/bash'
            vim.o.shellcmdflag = '-c'
            local overseer = require 'overseer'
            overseer.setup {
                templates = { 'builtin' },
                task_list = {
                    direction = 'bottom',
                    bindings = {
                        ['<CR>'] = 'RunAction',
                        ['<C-e>'] = 'Edit',
                        ['<C-j>'] = false,
                        ['<C-k>'] = false,
                    },
                    default_detail = 1,
                },
            }
        end,
        dependencies = {
            'nvim-telescope/telescope.nvim',
        },
        event = 'VeryLazy',
    },
}

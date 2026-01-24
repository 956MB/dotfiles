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
            local overseer = require 'overseer'
            overseer.setup {
                templates = { 'builtin', 'vscode' },
                task_list = {
                    direction = 'right',
                    bindings = {
                        ['<CR>'] = 'RunAction',
                        ['<C-e>'] = 'Edit',
                    },
                    default_detail = 1,
                },
            }

            local ok, tasks = pcall(dofile, vim.fn.getcwd() .. '/.nvim/tasks.lua')
            if ok and tasks.builder then
                local task_list = tasks.builder()
                for _, task in ipairs(task_list) do
                    overseer.new_task(task)
                end
            end
        end,
        dependencies = {
            'nvim-telescope/telescope.nvim',
        },
        event = 'VeryLazy',
    },
}

return {
    { -- Fixing gx with OIL
        'chrishrb/gx.nvim',
        keys = { { 'gx', '<cmd>Browse<cr>', mode = { 'n', 'v' } } },
        cmd = { 'Browse' },
        init = function()
            vim.g.netrw_nogx = 1 -- disable netrw gx
        end,
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
        },
        config = true,
        submodules = false,
    },

    { -- File tree
        'nvim-tree/nvim-tree.lua',
        version = '*',
        lazy = false,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'antosha417/nvim-lsp-file-operations',
            'echasnovski/mini.base16',
        },
        config = function()
            require('nvim-tree').setup {
                view = {
                    width = 40,
                    side = 'right',
                },
                renderer = {
                    root_folder_label = ':~:s?$?/..?',
                    icons = {
                        glyphs = {
                            git = {
                                unstaged = '~',
                                staged = '+',
                                unmerged = 'x',
                                renamed = '>',
                                untracked = '?',
                                deleted = '-',
                                ignored = '!',
                            },
                        },
                    },
                },
                filters = {
                    custom = { '.DS_Store' },
                    git_ignored = false,
                },
                update_focused_file = {
                    enable = true,
                    update_root = true,
                    ignore_list = {},
                },
            }
        end,
    },
}

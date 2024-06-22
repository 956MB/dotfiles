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

    { -- IDE like file tree
        'nvim-neo-tree/neo-tree.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'kyazdani42/nvim-web-devicons',
            'MunifTanjim/nui.nvim',
        },
        keys = {
            {
                '<leader>E',
                function()
                    require('neo-tree.command').execute { dir = vim.loop.cwd() }
                end,
                desc = 'Explorer NeoTree (cwd)',
            },
        },
        config = function()
            require('neo-tree').setup {
                source_selector = {
                    winbar = true,
                },
                filesystem = {
                    filtered_items = {
                        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                            '.DS_Store',
                        },
                    },
                    window = {
                        position = 'right',
                        mappings = {
                            ['<cr>'] = 'open',
                            ['<esc>'] = 'revert_preview',
                            ['P'] = { 'toggle_preview', config = { use_float = true } },
                            ['l'] = 'focus_preview',
                            ['C'] = 'close_node',
                            ['z'] = 'close_all_nodes',
                            ['a'] = {
                                'add',
                                -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
                                -- some commands may take optional config options, see `:h neo-tree-mappings` for details
                                config = {
                                    show_path = 'none', -- "none", "relative", "absolute"
                                },
                            },
                            ['A'] = 'add_directory', -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
                            ['d'] = 'delete',
                            ['r'] = 'rename',
                            ['y'] = 'copy_to_clipboard',
                            ['x'] = 'cut_to_clipboard',
                            ['p'] = 'paste_from_clipboard',
                            ['c'] = 'copy', -- takes text input for destination, also accepts the optional config.show_path option like "add":
                            ['m'] = 'move', -- takes text input for destination, also accepts the optional config.show_path option like "add".
                            ['q'] = 'close_window',
                            ['R'] = 'refresh',
                            ['?'] = 'show_help',
                            ['['] = 'prev_source',
                            [']'] = 'next_source',
                            ['g.'] = 'toggle_hidden',
                        },
                    },
                },
                buffers = {
                    window = {
                        mappings = {
                            ['['] = 'prev_source',
                            [']'] = 'next_source',
                        },
                    },
                },
                git_status = {
                    window = {
                        mappings = {
                            ['['] = 'prev_source',
                            [']'] = 'next_source',
                        },
                    },
                },
            }
        end,
    },
}

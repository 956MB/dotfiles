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

    { -- OIL
        'stevearc/oil.nvim',
        dependencies = {
            { 'nvim-tree/nvim-web-devicons' },
        },
        config = function()
            require('oil').setup {
                default_file_explorer = true,
                keymaps = {
                    ['<BS>'] = 'actions.parent', -- changed to backspace
                },
                view_options = {
                    show_hidden = true,
                },
            }
        end,
    },

    { -- IDE like file tree
        'nvim-neo-tree/neo-tree.nvim',
        keys = {
            {
                '<leader>E',
                function()
                    require('neo-tree.command').execute { dir = require('lazyvim.util').root.get() }
                end,
                desc = 'Explorer NeoTree (root dir)',
            },
            {
                '<leader>e',
                function()
                    require('neo-tree.command').execute { dir = vim.loop.cwd() }
                end,
                desc = 'Explorer NeoTree (cwd)',
            },
        },
        config = function()
            require('neo-tree').setup {
                filesystem = {
                    filtered_items = {
                        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                            '.DS_Store',
                        },
                    },
                },
                window = {
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
                        ['<'] = 'prev_source',
                        ['>'] = 'next_source',
                        ['H'] = 'toggle_hidden',
                    },
                },
            }
        end,
    },
}

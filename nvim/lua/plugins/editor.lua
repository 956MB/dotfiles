return {
    'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

    { -- Auto close pairs of characters
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {
            add_pairs = { -- Add additional pairs to the list
                ['('] = ')',
                ['['] = ']',
                ['{'] = '}',
                ["'"] = "'",
                ['"'] = '"',
                ['<'] = '>',
            },
        },
    },

    { -- Useful plugin to show you pending keybinds.
        'folke/which-key.nvim',
        event = 'VimEnter', -- Sets the loading event to 'VimEnter'
        config = function() -- This is the function that runs, AFTER loading
            require('which-key').setup()
        end,
    },

    { -- Find and replace text
        'nvim-pack/nvim-spectre',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },

    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {
                signs = {
                    add = { text = '│' },
                    change = { text = '│' },
                    delete = { text = '│' },
                    topdelete = { text = '│' },
                    changedelete = { text = '│' },
                },
            }
            require('scrollbar.handlers.gitsigns').setup()
        end,
    },

    { -- Scrollbar (with gitsigns)
        -- TODO: Add support in my own fork for show/hide of marks as well as the scrollbar itself
        -- https://github.com/petertriho/nvim-scrollbar/issues/18
        'petertriho/nvim-scrollbar',
        dependencies = { 'lewis6991/gitsigns.nvim' },
        config = function()
            require('scrollbar').setup {
                set_highlights = false,
                marks = {
                    Cursor = {
                        text = '─',
                    },
                    GitAdd = {
                        text = '│',
                    },
                    GitChange = {
                        text = '│',
                    },
                    GitDelete = {
                        text = '│',
                    },
                    -- Warn = { highlight = 'DiagnosticVirtualTextWarn' },
                    -- Info = { color = colors.info },
                    -- Hint = { color = colors.hint },
                    -- Misc = { color = colors.purple },
                },
            }
        end,
    },

    {
        'stevearc/quicker.nvim',
        config = function()
            require('quicker').setup {
                keys = {
                    {
                        '>',
                        function()
                            require('quicker').expand { before = 2, after = 2, add_to_existing = true }
                        end,
                        desc = 'Expand quickfix context',
                    },
                    {
                        '<',
                        function()
                            require('quicker').collapse()
                        end,
                        desc = 'Collapse quickfix context',
                    },
                },
            }
        end,
    },

    { -- Toggle comment lines with Comment.nvim
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()

            local api = require 'Comment.api'
            vim.keymap.set('n', '<C-l>', api.call('toggle.linewise.current', 'g@$'), { expr = true })
            vim.keymap.set('v', '<C-l>', api.call('toggle.linewise', 'g@'), { expr = true })
        end,
    },
}

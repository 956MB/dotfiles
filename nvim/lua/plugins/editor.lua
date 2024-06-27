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

            -- Document existing key chains
            require('which-key').register {
                ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
                ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
                ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
                ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
                ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
            }
        end,
    },

    { -- Find and replace text
        'nvim-pack/nvim-spectre',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },

    -- See `:help gitsigns` to understand what the configuration keys do
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {
                signs = {
                    add = { text = '-' },
                    change = { text = '-' },
                    delete = { text = '-' },
                    topdelete = { text = '-' },
                    changedelete = { text = '-' },
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
                        text = '-',
                    },
                    GitChange = {
                        text = '-',
                    },
                    GitDelete = {
                        text = '-',
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

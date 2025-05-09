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

    { -- Shows available keybindings
        'folke/which-key.nvim',
        event = 'VeryLazy',
        keys = {
            {
                '<leader>?',
                function()
                    require('which-key').show { global = false }
                end,
                desc = 'Buffer Local Keymaps (which-key)',
            },
        },
    },

    { -- Trying grug-far for find and replace
        'MagicDuck/grug-far.nvim',
        config = function()
            require('grug-far').setup {}
        end,
    },

    { -- Current file search and replace popup
        'chrisgrieser/nvim-rip-substitute',
        cmd = 'RipSubstitute',
        opts = {},
        -- Delete existing popup buffer causing problems
        init = function()
            local popupWin = require 'rip-substitute.popup-win'
            local origOpen = popupWin.openSubstitutionPopup
            popupWin.openSubstitutionPopup = function(...)
                local popupBufName = '[RipSubstitute]'
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == popupBufName then
                        vim.api.nvim_buf_delete(buf, { force = true })
                    end
                end
                return origOpen(...)
            end
        end,
        keys = {
            { -- n: whole buffer, V: visual line selection
                '<leader>fs',
                function()
                    require('rip-substitute').sub()
                end,
                mode = { 'n', 'x' },
                desc = ' rip substitute',
            },
        },
    },

    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        event = 'BufReadPre',
        config = function()
            require('gitsigns').setup {
                signs = {
                    -- ┆, ┊, ┋, ┇, │
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
                        text = '┊',
                    },
                    GitChange = {
                        text = '┊',
                    },
                    GitDelete = {
                        text = '┊',
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

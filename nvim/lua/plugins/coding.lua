return {
    { -- Autoformat
        'stevearc/conform.nvim',
        lazy = false,
        keys = {
            {
                '<leader>f',
                function()
                    require('conform').format { async = true, lsp_fallback = true }
                end,
                mode = '',
                desc = '[F]ormat buffer',
            },
        },
        opts = {
            notify_on_error = false,
            -- format_on_save = function(bufnr)
            --     -- Disable "format_on_save lsp_fallback" for languages that don't
            --     -- have a well standardized coding style. You can add additional
            --     -- languages here or re-enable it for the disabled ones.
            --     local disable_filetypes = { c = true, cpp = true }
            --     return {
            --         timeout_ms = 500,
            --         lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
            --     }
            -- end,
            formatters_by_ft = {
                css = { 'prettierd', 'prettier' },
                lua = { 'stylua' },
                go = { 'goimports', 'gofmt' },
                javascript = { { 'prettierd', 'prettier' } },
                python = {
                    {
                        exe = 'black',
                        args = { '--line-length', '88', '--fast', '-' },
                        stdin = true,
                    },
                },
            },
        },
    },

    { -- Back/forward navigation
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },

    { -- Collection of various small independent plugins/modules
        'echasnovski/mini.nvim',
        config = function()
            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --  - ci'  - [C]hange [I]nside [']quote
            require('mini.ai').setup { n_lines = 500 }

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            --
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd'   - [S]urround [D]elete [']quotes
            -- - sr)'  - [S]urround [R]eplace [)] [']
            require('mini.surround').setup()
        end,
    },

    { -- Indentation scope animation NONE
        'echasnovski/mini.indentscope',
        event = 'LazyFile',
        opts = function(_, opts)
            opts.draw = {
                delay = 0,
                animation = require('mini.indentscope').gen_animation.none(),
            }
        end,
    },

    { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        opts = {
            ensure_installed = { 'bash', 'c', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'vim', 'vimdoc' },
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { 'ruby' },
            },
            indent = { enable = true, disable = { 'ruby' } },
        },
        config = function(_, opts)
            -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
            ---@diagnostic disable-next-line: missing-fields
            require('nvim-treesitter.configs').setup(opts)
        end,
    },

    { -- Align text
        'Vonr/align.nvim',
        branch = 'v2',
        init = function()
            vim.keymap.set('x', 'aa', function()
                require('align').align_to_char {
                    length = 1,
                }
            end, { noremap = true, silent = true })
        end,
    },

    {
        'folke/trouble.nvim',
        branch = 'main',
        cmd = 'Trouble',
        keys = {
            {
                '<leader>xx',
                '<cmd>Trouble diagnostics toggle<cr>',
                desc = 'Diagnostics (Trouble)',
            },
            {
                '<leader>xX',
                '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
                desc = 'Buffer Diagnostics (Trouble)',
            },
            {
                '<leader>cs',
                '<cmd>Trouble symbols toggle focus=false<cr>',
                desc = 'Symbols (Trouble)',
            },
            {
                '<leader>cl',
                '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
                desc = 'LSP Definitions / references / ... (Trouble)',
            },
            {
                '<leader>xL',
                '<cmd>Trouble loclist toggle<cr>',
                desc = 'Location List (Trouble)',
            },
            {
                '<leader>xQ',
                '<cmd>Trouble qflist toggle<cr>',
                desc = 'Quickfix List (Trouble)',
            },
        },
        config = function()
            require('trouble').setup {
                auto_open = false,
                auto_close = false,
                auto_preview = true,
                focus = true,
                auto_jump = {},
                mode = 'quickfix',
                severity = vim.diagnostic.severity.ERROR,
                cycle_results = true,
            }

            vim.api.nvim_create_autocmd('User', {
                pattern = { 'XcodebuildBuildFinished', 'XcodebuildTestsFinished' },
                callback = function(event)
                    if event.data.cancelled then
                        return
                    end

                    if event.data.success then
                        require('trouble').close()
                    elseif not event.data.failedCount or event.data.failedCount > 0 then
                        if next(vim.fn.getqflist()) then
                            require('trouble').open { focus = false }
                        else
                            require('trouble').close()
                        end

                        require('trouble').refresh()
                    end
                end,
            })
        end,
    },

    { -- Multi cusor editing
        'smoka7/multicursors.nvim',
        event = 'VeryLazy',
        dependencies = {
            'smoka7/hydra.nvim',
        },
        opts = {},
        cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
        keys = {
            {
                mode = { 'v', 'n' },
                '<C-d>',
                '<cmd>MCstart<cr>',
                desc = 'Create a selection for selected text or word under the cursor',
            },
        },
    },

    { -- Github Copliot
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        config = function()
            require('copilot').setup {
                panel = {
                    enabled = true,
                    auto_refresh = false,
                    keymap = {
                        jump_prev = '[[',
                        jump_next = ']]',
                        accept = '<CR>',
                        refresh = 'gr',
                        open = '<M-CR>',
                    },
                    layout = {
                        position = 'bottom', -- | top | left | right
                        ratio = 0.4,
                    },
                },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = '<C-CR>',
                        accept_word = false,
                        accept_line = false,
                        next = '<M-]>',
                        prev = '<M-[>',
                        dismiss = '<C-]>',
                    },
                },
                filetypes = {
                    yaml = false,
                    markdown = true,
                    help = false,
                    gitcommit = false,
                    gitrebase = false,
                    hgcommit = false,
                    svn = false,
                    cvs = false,
                    ['.'] = false,
                },
                copilot_node_command = 'node', -- Node.js version must be > 18.x
                server_opts_overrides = {},
            }
        end,
    },
}

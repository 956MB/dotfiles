return {
    {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        config = function()
            local handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = (' 󰁂 %d '):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, { suffix, 'UfoSuffixHighlight' })
                return newVirtText
            end

            require('ufo').setup {
                fold_virt_text_handler = handler,
                provider_selector = function(_, _, _)
                    return { 'treesitter', 'indent' }
                end,
            }
        end,
    },

    { -- Running tests
        'nvim-neotest/neotest',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'antoinemadec/FixCursorHold.nvim',
            'rouge8/neotest-rust',
        },
        config = function()
            local neotest = require 'neotest'

            neotest.setup {
                adapters = {
                    require 'neotest-rust',
                },
            }

            vim.keymap.set('n', '<leader>tt', function()
                neotest.run.run()
            end, { desc = 'Run nearest test' })
            vim.keymap.set('n', '<leader>tf', function()
                neotest.run.run(vim.fn.expand '%')
            end, { desc = 'Run file tests' })
            vim.keymap.set('n', '<leader>ts', function()
                neotest.summary.toggle()
            end, { desc = 'Toggle test summary' })
        end,
    },

    { -- Autoformat
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
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
            --     local disable_filetypes = { c = true, cpp = true, js = true }
            --     return {
            --         timeout_ms = 499,
            --         lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
            --     }
            -- end,
            formatters_by_ft = {
                rust = { 'rustfmt' },
                css = { 'prettierd', 'prettier' },
                lua = { 'stylua' },
                go = { 'goimports', 'gofmt' },
                -- javascript = { { 'prettierd', 'prettier' } },
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

    { -- Neovide project explorer
        'Rics-Dev/project-explorer.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
        },
        opts = {
            paths = { '~/Dev/*' },
            newProjectPath = '~/Dev/',
            file_explorer = function(dir)
                require('oil').open(dir)
            end,
        },
        config = function(_, opts)
            require('project_explorer').setup(opts)
        end,
        keys = {
            { '<leader>fp', '<cmd>ProjectExplorer<cr>', desc = 'Project Explorer' },
        },
        lazy = false,
    },

    { -- Indentation scope animation NONE
        'echasnovski/mini.indentscope',
        event = 'LazyFile',
        opts = function(_, opts)
            opts.symbol = '│'
            opts.draw = {
                delay = 0,
                animation = require('mini.indentscope').gen_animation.none(),
            }
        end,
    },

    { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        event = 'BufReadPost',
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
                '<leader>XX',
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

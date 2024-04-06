return {
    { -- Telescope file browser
        'nvim-telescope/telescope-file-browser.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    },

    { -- Telescope (fuzzy finder, file picker, etc.)
        'nvim-telescope/telescope.nvim',
        -- 'custom/telescope.nvim',
        -- vim.fn.stdpath 'data' .. '/lazy/plugins/custom/telescope.nvim',
        event = 'VimEnter',
        -- branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { -- If encountering errors, see telescope-fzf-native README for installation instructions
                'nvim-telescope/telescope-fzf-native.nvim',

                -- `build` is used to run some command when the plugin is installed/updated.
                -- This is only run then, not every time Neovim starts up.
                build = 'make',

                -- `cond` is a condition used to determine whether this plugin should be
                -- installed and loaded.
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            { 'nvim-telescope/telescope-ui-select.nvim' },

            -- Useful for getting pretty icons, but requires a Nerd Font.
            { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
        },
        config = function()
            -- See `:help telescope.builtin`
            local builtin = require 'telescope.builtin'
            local previewers = require 'telescope.previewers'
            local sorters = require 'telescope.sorters'

            -- [[ Configure Telescope ]]
            -- See `:help telescope` and `:help telescope.setup()`
            require('telescope').setup {
                extensions = {
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown(),
                    },
                },
            }

            -- Enable Telescope extensions if they are installed
            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')

            local map = vim.keymap.set

            map('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
            map('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
            map('n', '<C-p>', builtin.find_files, { desc = '[S]earch [F]iles' })
            map('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
            map('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
            map('n', '<C-g>', builtin.live_grep, { desc = '[S]earch by [G]rep' })
            map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
            map('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
            map('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
            map('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
            map('n', '<C-b>', '<Cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>', { desc = 'Open file browser (Normal Mode)' })

            -- Slightly advanced example of overriding default behavior and theme
            map('n', '<C-f>', function()
                -- You can pass additional configuration to Telescope to change the theme, layout, etc.
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    previewer = true,
                    selection_strategy = 'reset',
                    sorting_strategy = 'ascending',
                    file_sorter = sorters.get_fuzzy_file,
                    file_ignore_patterns = {
                        'gtk/**/*',
                        './node_modules/*',
                        'node_modules',
                        '^node_modules/*',
                        'node_modules/*',
                        '.git',
                        'pdf_viewer',
                        'src-tauri/target/*',
                        'src-tauri/target/*',
                        'src-tauri/target/*',
                    },
                    generic_sorter = sorters.get_generic_fuzzy_sorter,
                    file_previewer = previewers.vim_buffer_cat.new,
                    grep_previewer = previewers.vim_buffer_vimgrep.new,
                    qflist_previewer = previewers.vim_buffer_qflist.new,
                    layout_strategy = 'horizontal',
                    layout_config = {
                        horizontal = {
                            prompt_position = 'top',
                            preview_width = 0.55,
                            results_width = 0.8,
                        },
                        vertical = {
                            mirror = false,
                        },
                        width = 0.87,
                        height = 0.80,
                        preview_cutoff = 120,
                    },
                })
            end, { desc = '[/] Fuzzily search in current buffer' })

            -- It's also possible to pass additional configuration options.
            --  See `:help telescope.builtin.live_grep()` for information about particular keys
            map('n', '<leader>s/', function()
                builtin.live_grep {
                    grep_open_files = true,
                    prompt_title = 'Live Grep in Open Files',
                }
            end, { desc = '[S]earch [/] in Open Files' })

            -- Shortcut for searching your Neovim configuration files
            map('n', '<leader>sn', function()
                builtin.find_files { cwd = vim.fn.stdpath 'config' }
            end, { desc = '[S]earch [N]eovim files' })

            -- See `:help telescope.builtin`
            map('n', '<leader>?', require('telescope.builtin').oldfiles, {
                desc = '[?] Find recently opened files',
            })
            map('n', '<leader><space>', require('telescope.builtin').buffers, {
                desc = '[ ] Find existing buffers',
            })
        end,
    },
}

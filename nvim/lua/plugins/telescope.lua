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

            local harpoon = require 'harpoon'
            harpoon:setup {}

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

            local function map(lhs, rhs, opts)
                opts = opts or {}
                opts.silent = opts.silent ~= false
                vim.keymap.set('n', lhs, rhs, opts)
            end

            local ignore_patterns = {
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
                'vendor/*',
            }

            local layout = {
                horizontal = {
                    preview_width = 0.55,
                    results_width = 0.8,
                },
                vertical = {
                    mirror = false,
                },
                prompt_position = 'top',
                width = 0.87,
                height = 0.60,
                preview_cutoff = 120,
            }

            map('<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
            map('<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
            map('<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
            map('<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
            map('<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
            map('<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
            map('<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
            map('<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
            map('<C-b>', '<Cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>', { desc = 'Open file browser (Normal Mode)' })
            map('<C-g>', function()
                builtin.live_grep {
                    layout_config = layout,
                    file_ignore_patterns = ignore_patterns,
                }
            end, { desc = '[S]earch by [G]rep' })
            map('<C-p>', function()
                builtin.find_files {
                    layout_config = layout,
                    file_ignore_patterns = ignore_patterns,
                }
            end, { desc = '[S]earch [F]iles' })
            map('<C-t>', function()
                builtin.buffers {
                    layout_config = layout,
                    file_ignore_patterns = ignore_patterns,
                }
            end, { desc = '[S]earch [T]abs (Buffers)' })

            -- Slightly advanced example of overriding default behavior and theme
            map('<C-f>', function()
                -- You can pass additional configuration to Telescope to change the theme, layout, etc.
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    previewer = true,
                    selection_strategy = 'reset',
                    sorting_strategy = 'ascending',
                    file_sorter = sorters.get_fuzzy_file,
                    file_ignore_patterns = ignore_patterns,
                    generic_sorter = sorters.get_generic_fuzzy_sorter,
                    file_previewer = previewers.vim_buffer_cat.new,
                    grep_previewer = previewers.vim_buffer_vimgrep.new,
                    qflist_previewer = previewers.vim_buffer_qflist.new,
                    layout_strategy = 'horizontal',
                    layout_config = layout,
                })
            end, { desc = '[/] Fuzzily search in current buffer' })

            -- Harpoon using Telescope UI
            local conf = require('telescope.config').values
            local function toggle_telescope(harpoon_files)
                local file_paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(file_paths, item.value)
                end

                require('telescope.pickers')
                    .new({}, {
                        prompt_title = 'Harpoon',
                        finder = require('telescope.finders').new_table {
                            results = file_paths,
                        },
                        previewer = conf.file_previewer {},
                        sorter = conf.generic_sorter {},
                        layout_config = layout,
                    })
                    :find()
            end

            map('<C-e>', function()
                toggle_telescope(harpoon:list())
            end, { desc = 'Open Harpoon window' })

            -- It's also possible to pass additional configuration options.
            --  See `:help telescope.builtin.live_grep()` for information about particular keys
            map('<leader>s/', function()
                builtin.live_grep {
                    grep_open_files = true,
                    prompt_title = 'Live Grep in Open Files',
                }
            end, { desc = '[S]earch [/] in Open Files' })

            -- Shortcut for searching your Neovim configuration files
            map('<leader>sn', function()
                builtin.find_files { cwd = vim.fn.stdpath 'config' }
            end, { desc = '[S]earch [N]eovim files' })

            -- See `:help telescope.builtin`
            map('<leader>?', require('telescope.builtin').oldfiles, {
                desc = '[?] Find recently opened files',
            })
            map('<leader><space>', require('telescope.builtin').buffers, {
                desc = '[ ] Find existing buffers',
            })
        end,
    },
}

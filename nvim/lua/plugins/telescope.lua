return {
    { -- Telescope file browser
        'nvim-telescope/telescope-file-browser.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    },

    { -- Telescope (fuzzy finder, file picker, etc.)
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        -- 'custom/telescope.nvim',
        -- vim.fn.stdpath 'data' .. '/lazy/plugins/custom/telescope.nvim',
        -- event = 'VimEnter',
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

            -- [[ Configure Telescope ]]
            -- See `:help telescope` and `:help telescope.setup()`
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
            local main_layout = {
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

            require('telescope').setup {
                defaults = {
                    file_ignore_patterns = ignore_patterns,
                    prompt_prefix = '   ',
                    selection_caret = '┃ ',
                    layout_config = main_layout,
                    extensions = {
                        ['ui-select'] = {
                            require('telescope.themes').get_dropdown(),
                        },
                    },
                },
            }

            -- Enable Telescope extensions if they are installed
            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')

            local function map(mode, lhs, rhs, opts)
                opts = opts or {}
                opts.silent = opts.silent ~= false
                vim.keymap.set(mode, lhs, rhs, opts)
            end

            -- Send visual selection to Telescope func
            local function telescope_visual(builtin_func, opts)
                return function()
                    local saved_reg = vim.fn.getreg 'v'
                    vim.cmd 'noau normal! "vy"'
                    local selection = vim.fn.getreg 'v'
                    vim.fn.setreg('v', saved_reg)
                    builtin_func(vim.tbl_extend('force', opts or {}, { default_text = selection }))
                end
            end

            local function create_picker(builtin_func, opts)
                return function()
                    if vim.fn.mode() == 'v' then
                        telescope_visual(builtin_func, opts)()
                    else
                        builtin_func(opts)
                    end
                end
            end

            map({ 'n', 'v' }, '<leader>sh', create_picker(builtin.help_tags), { desc = '[S]earch [H]elp' })
            map({ 'n', 'v' }, '<leader>sk', create_picker(builtin.keymaps), { desc = '[S]earch [K]eymaps' })
            map({ 'n', 'v' }, '<leader>ss', create_picker(builtin.builtin), { desc = '[S]earch [S]elect Telescope' })
            map({ 'n', 'v' }, '<leader>sw', create_picker(builtin.grep_string), { desc = '[S]earch current [W]ord' })
            map({ 'n', 'v' }, '<leader>sd', create_picker(builtin.diagnostics), { desc = '[S]earch [D]iagnostics' })
            map({ 'n', 'v' }, '<leader>sr', create_picker(builtin.resume), { desc = '[S]earch [R]esume' })
            map({ 'n', 'v' }, '<leader>s.', create_picker(builtin.oldfiles), { desc = '[S]earch Recent Files ("." for repeat)' })
            map({ 'n', 'v' }, '<C-g>', create_picker(builtin.live_grep), { desc = '[S]earch by [G]rep' })
            map({ 'n', 'v' }, '<C-p>', create_picker(builtin.find_files), { desc = '[S]earch [F]iles' })
            map({ 'n', 'v' }, '<C-t>', create_picker(builtin.buffers), { desc = '[S]earch [T]abs (Buffers)' })
            map(
                { 'n', 'v' },
                '<leader>s/',
                create_picker(builtin.live_grep, {
                    grep_open_files = true,
                    prompt_title = 'Live Grep in Open Files',
                }),
                { desc = '[S]earch [/] in Open Files' }
            )
            map({ 'n', 'v' }, '<leader>sn', create_picker(builtin.find_files, { cwd = vim.fn.stdpath 'config' }), { desc = '[S]earch [N]eovim files' })
            map({ 'n', 'v' }, '<leader>?', create_picker(builtin.oldfiles), { desc = '[?] Find recently opened files' })
            map({ 'n', 'v' }, '<leader><space>', create_picker(builtin.buffers), { desc = '[ ] Find existing buffers' })
        end,
    },
}

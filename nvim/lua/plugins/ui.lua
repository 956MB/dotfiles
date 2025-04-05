local Util = require 'lazyvim.util'
local cfg_utils = require 'config.utils'

-- like lazyvim.util.lualine.pretty_path but with a longer path (3 -> 6)
---@param opts? {relative: "cwd"|"root", modified_hl: string?}
local function lualine_pretty_path(opts)
    opts = vim.tbl_extend('force', {
        relative = 'cwd',
        modified_hl = 'Comment',
    }, opts or {})

    return function(self)
        local path = vim.fn.expand '%:p' --[[@as string]]

        if path == '' then
            return ''
        end
        local root = Util.root.get { normalize = true }
        local cwd = Util.root.cwd()

        if opts.relative == 'cwd' and path:find(cwd, 1, true) == 1 then
            path = path:sub(#cwd + 2)
        else
            path = path:sub(#root + 2)
        end

        local sep = package.config:sub(1, 1)
        local parts = vim.split(path, '[\\/]')
        if #parts > 6 then
            parts = { parts[1], parts[2], parts[3], parts[4], '…', parts[#parts - 1], parts[#parts] }
        end

        if opts.modified_hl and vim.bo.modified then
            parts[#parts] = Util.lualine.format(self, parts[#parts], opts.modified_hl)
        end

        return table.concat(parts, sep)
    end
end

return {
    { -- Notifications
        'rcarriga/nvim-notify',
        config = function()
            require('notify').setup {
                filter = function(_, win)
                    local bufnr = vim.api.nvim_win_get_buf(win)
                    local buftype = vim.api.nvim_get_option_value('buftype', { buf = bufnr })
                    return buftype ~= 'help'
                end,
            }
        end,
    },

    { -- Cheatsheet
        'sudormrfbin/cheatsheet.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
        },
    },

    { -- Better whitespace visualization (vscode style)
        'mcauley-penney/visual-whitespace.nvim',
        config = true,
        -- keys = { 'v', 'V', '<C-v>' }, -- optionally, lazy load on visual mode keys
    },

    { -- Better cmdline
        'folke/noice.nvim',
        event = 'VeryLazy',
        dependencies = {
            'rcarriga/nvim-notify',
        },
        config = function()
            require('noice').setup {
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                        ['vim.lsp.util.stylize_markdown'] = true,
                        ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true, -- use a classic bottom cmdline for search
                    -- command_palette = true, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false, -- add a border to hover docs and signature help
                },
                views = {
                    cmdline_popup = {
                        postion = {
                            row = '50%',
                            col = '50%',
                        },
                        win_options = {
                            winhighlight = {
                                Normal = 'NoiceCmdlineNormal',
                                FloatBorder = 'NoiceCmdlinePopupBorder',
                                FloatTitle = 'NoiceCmdlinePopupTitle',
                            },
                        },
                    },
                },
            }
        end,
    },

    { -- Better hex color preview i think
        'uga-rosa/ccc.nvim',
        opts = {
            highlighter = {
                auto_enable = true,
                lsp = true,
                filetypes = {
                    'html',
                    'lua',
                    'css',
                    'scss',
                    'sass',
                    'less',
                    'stylus',
                    'javascript',
                    'tmux',
                    'typescript',
                    'conf',
                    'toml',
                    'yaml',
                },
                excludes = { 'lazy', 'mason', 'help', 'neo-tree' },
            },
        },
    },

    { -- Integrated terminal
        'akinsho/toggleterm.nvim',
        version = '*',
        cmd = 'ToggleTerm',
        keys = {
            {
                '<C-\\>',
                '<cmd>ToggleTerm direction=float<CR>',
                { desc = '[T]oggleTerm [F]loat' },
            },
            {
                '<leader>vt',
                '<cmd>ToggleTerm direction=vertical<CR>',
                { desc = '[T]oggleTerm [V]ertical' },
            },
            {
                '<leader>ht',
                '<cmd>ToggleTerm direction=horizontal<CR>',
                { desc = '[T]oggleTerm [H]orizontal' },
            },
        },
        config = function()
            require('toggleterm').setup {
                persist_mode = true,
                size = function(term)
                    if term.direction == 'horizontal' then
                        return 20
                    elseif term.direction == 'vertical' then
                        return vim.o.columns * 0.4
                    end
                end,
                float_opts = {
                    border = 'curved',
                    title_pos = 'center',
                },
                on_open = function(term)
                    vim.api.nvim_set_option_value('winhighlight', 'Normal:Normal', { win = term.window })

                    local opts = { buffer = term.bufnr }
                    vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-W>k]], opts)
                    vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-W>j]], opts)
                    vim.keymap.set('t', '<C-S-j>', [[<C-\><C-n><C-W>h]], opts)
                    vim.keymap.set('t', '<C-S-k>', [[<C-\><C-n><C-W>l]], opts)

                    -- Resize terminal split works
                    vim.keymap.set('t', '<C-,>', function()
                        vim.cmd.stopinsert()
                        cfg_utils.scale_split '-1'
                        vim.cmd.startinsert()
                    end, opts)
                    vim.keymap.set('t', '<C-.>', function()
                        vim.cmd.stopinsert()
                        cfg_utils.scale_split '+1'
                        vim.cmd.startinsert()
                    end, opts)

                    -- Enter insert mode when focusing terminal window
                    vim.cmd 'autocmd BufEnter <buffer> startinsert'
                end,
            }
        end,
    },

    { -- ^^ Better than opening lazygit in a terminal with toggleterm (TermExec)
        'kdheepak/lazygit.nvim',
        cmd = {
            'LazyGit',
            'LazyGitConfig',
            'LazyGitCurrentFile',
            'LazyGitFilter',
            'LazyGitFilterCurrentFile',
        },
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        keys = {
            { '<leader>lg', cfg_utils.open_lazygit_tab, desc = 'LazyGit in Buffer' },
        },
        config = function()
            vim.g.lazygit_floating_window_use_plenary = 0 -- Disable floating window
        end,
    },

    { -- Git diff previews
        'tanvirtin/vgit.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
        event = 'VimEnter',
        config = function()
            require('vgit').setup {
                settings = {
                    live_blame = {
                        enabled = false,
                    },
                },
            }
        end,
    },

    { -- Something for deleting tabs and buffers
        'famiu/bufdelete.nvim',
    },

    { -- Tabs
        'akinsho/bufferline.nvim',
        version = '*',
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = function(_, opts)
            opts.options = vim.tbl_deep_extend('force', opts.options, {
                indicator = {
                    icon = '┃',
                    style = 'icon',
                },
                show_buffer_close_icons = false,
                always_show_bufferline = false,
                hover = {
                    enabled = true,
                    delay = 0,
                    reveal = { 'close' },
                },
                diagnostics = 'nvim_lsp',
                color_icons = true, -- whether or not to add the filetype icon highlights
                show_buffer_icons = true, -- disable filetype icons for buffers
            })
        end,
        config = function(_, opts)
            local bufferline = require 'bufferline'
            bufferline.setup(opts)

            local bufferline_visible = true
            _G.toggle_bufferline = function()
                bufferline_visible = not bufferline_visible
                if bufferline_visible then
                    vim.opt.showtabline = 1 -- 0: never, 1: only multiple tabs, 2: always
                    bufferline.setup(opts)
                else
                    vim.opt.showtabline = 0
                end
            end

            vim.api.nvim_create_user_command('ToggleBufferline', 'lua _G.toggle_bufferline()', {})
            vim.keymap.set('n', '<leader>tb', '<cmd>lua _G.toggle_bufferline()<CR>', { noremap = true, silent = true, desc = 'Toggle bufferline visibility' })
        end,
    },

    { -- Cursor line highlight
        'jake-stewart/force-cul.nvim',
        config = function()
            require('force-cul').setup()
        end,
    },

    { -- Statusline
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = function(_, opts)
            local function xcodebuild_device()
                if vim.g.xcodebuild_platform == 'macOS' then
                    return ' macOS'
                end
                if vim.g.xcodebuild_os then
                    return ' ' .. vim.g.xcodebuild_device_name .. ' (' .. vim.g.xcodebuild_os .. ')'
                end
                return ' ' .. vim.g.xcodebuild_device_name
            end

            -- filename.ext \\\ line:col
            local function inactive_statusline()
                local width = vim.fn.winwidth(0)
                local filename = vim.fn.expand '%:t'
                local position = string.format('%d:%d', vim.fn.line '.', vim.fn.col '.')
                local backslash_count = width - #filename - #position - 4
                local backslashes = string.rep('\\', backslash_count)

                return string.format('%s %s %s', filename, backslashes, position)
            end
            local function short(str)
                local modes = {
                    ['NORMAL'] = 'NOR',
                    ['INSERT'] = 'INS',
                    ['VISUAL'] = 'VIS',
                    ['V-LINE'] = 'V-L',
                    ['V-BLOCK'] = 'V-B',
                    ['REPLACE'] = 'REP',
                    ['COMMAND'] = 'CMD',
                    ['TERMINAL'] = 'TER',
                    ['EX'] = 'EX',
                    ['SELECT'] = 'SEL',
                    ['S-LINE'] = 'S-L',
                    ['S-BLOCK'] = 'S-B',
                    ['OPERATOR'] = 'OPE',
                    ['MORE'] = 'MOR',
                    ['CONFIRM'] = 'CON',
                    ['SHELL'] = 'SHL',
                    ['MULTICHAR'] = 'MCH',
                    ['PROMPT'] = 'PRT',
                    ['BLOCK'] = 'BLK',
                    ['FUNCTION'] = 'FUN',
                }
                return modes[str] or str
            end

            -- opts.options.theme = 'vscode'
            opts.options.disabled_filetypes = {
                statusline = { 'NvimTree' },
                winbar = {},
            }
            -- opts.sections.lualine_a = { { 'mode', separator = { left = '', right = '' }, fmt = short } }
            opts.sections.lualine_c[4] = { lualine_pretty_path() }
            -- middle --
            -- opts.sections.lualine_z = {
            --     { 'location', separator = { left = '', right = '' } },
            -- }
            opts.sections.lualine_y = opts.sections.lualine_x
            opts.sections.lualine_x = {
                { "' ' .. vim.g.xcodebuild_last_status", color = { fg = '#a6e3a1' } },
                { xcodebuild_device, color = { fg = '#f9e2af', bg = '#161622' } },
                'encoding',
                { 'g:metals_status' },
            }
            opts.inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { inactive_statusline },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            }
            opts.tabline = {}
            opts.winbar = {}
            opts.inactive_winbar = {}
            opts.extensions = { 'nvim-dap-ui', 'quickfix', 'trouble', 'nvim-tree', 'lazy', 'mason' }
            opts.options.ignore_focus = {}
            opts.options.always_divide_middle = true
            opts.options.globalstatus = false
            opts.options.component_separators = { left = '', right = '' }
            opts.options.section_separators = { left = '', right = '' }
        end,
    },

    {
        'folke/persistence.nvim',
        opts = { autoload = false },
    },

    { -- Dashboard
        'goolord/alpha-nvim',
        event = 'VimEnter',
        enabled = true,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        init = false,
        opts = function()
            local dashboard = require 'alpha.themes.dashboard'
            local theta = require 'alpha.themes.theta'
            local cdir = vim.fn.getcwd()
            local mru_list = theta.mru(0, cdir, 5)
            dashboard.section.buttons.val = {
                {
                    type = 'group',
                    val = function()
                        if #mru_list.val > 0 then
                            return {
                                {
                                    type = 'text',
                                    val = 'Recent files',
                                    opts = {
                                        hl = 'SpecialComment',
                                        shrink_margin = false,
                                        position = 'center',
                                    },
                                },
                                { type = 'padding', val = 1 },
                                {
                                    type = 'group',
                                    val = function()
                                        return { mru_list }
                                    end,
                                    opts = { shrink_margin = false },
                                },
                                { type = 'padding', val = 1 },
                            }
                        else
                            return {}
                        end
                    end,
                },
                { type = 'padding', val = #mru_list.val > 0 and 1 or 0 },
                { type = 'text', val = 'Quick links', opts = { hl = 'SpecialComment', position = 'center' } },
                { type = 'padding', val = 1 },
                {
                    type = 'group',
                    val = {
                        dashboard.button('f', '󰱽 ' .. ' Find file', '<cmd> Telescope find_files <CR>'),
                        dashboard.button('g', '󱩾 ' .. ' Find text', '<cmd> Telescope live_grep <CR>'),
                        dashboard.button('n', ' ' .. ' New file', '<cmd> ene <CR>'),
                        dashboard.button('r', ' ' .. ' Recent files', '<cmd> Telescope oldfiles <CR>'),
                        dashboard.button('c', ' ' .. ' Config', '<cmd> lua require("lazyvim.util").telescope.config_files()() <CR>'),
                        -- dashboard.button('s', '󰁯 ' .. ' Restore Session', '<cmd> lua require("persistence").load() <CR>'),
                        dashboard.button(
                            's',
                            '󰁯 ' .. ' Restore Session',
                            '<cmd>lua require("persistence").load() vim.defer_fn(function() vim.cmd("doautocmd User SessionLoadPost") end, 10)<CR>'
                        ),
                        dashboard.button('u', ' ' .. ' Update plugins', '<cmd> Lazy sync <CR>'),
                        dashboard.button('l', '󰒲 ' .. ' Lazy', '<cmd> Lazy <CR>'),
                        dashboard.button('q', ' ' .. ' Quit', '<cmd> qa <CR>'),
                    },
                },
                { type = 'padding', val = 1 },
            }
            for _, button in ipairs(dashboard.section.buttons.val) do
                if button.on_press then
                    button.opts.hl = 'AlphaButtons'
                    button.opts.hl_shortcut = 'AlphaShortcut'
                end
            end

            local banner = [[
      ··////////////////////··/·   
    ·//·····/|/············/||/·   
   ·|·      ·|·           ·//·     
   /|       ·|·         ·//·       
   ·|/     ·/|·       ·//·         
    ·///////||·     ·//·           
       ···  ·|·    //·       ·/·   
            ·|·  /||·      ·//·    
            ·|//|//////···//·      
            ·||/·     ·||||·       
           ·//·       ///·//·      
         ·//·       /|/    ·|/     
       ·//·       ·//        //    
     ·//·       ·//·         ·|·   
    //·       ·/||/··········/|/   
   ··         ·/··////////////··   
]]
            local header = '\n\n\n\n\n\n' .. banner

            dashboard.section.header.val = vim.split(header, '\n')
            dashboard.section.header.opts.hl = 'AlphaHeader'
            dashboard.section.buttons.opts.hl = 'AlphaButtons'
            dashboard.section.buttons.opts.spacing = 0
            dashboard.section.footer.opts.hl = 'AlphaFooter'
            dashboard.config.layout = {
                { type = 'padding', val = 1 },
                dashboard.section.header,
                { type = 'padding', val = 1 },
                dashboard.section.buttons,
                { type = 'padding', val = 1 },
                dashboard.section.footer,
            }
            return dashboard
        end,

        -- Credits: https://github.com/LazyVim/LazyVim
        config = function(_, dashboard)
            -- close Lazy and re-open when the dashboard is ready
            if vim.o.filetype == 'lazy' then
                vim.cmd.close()
                vim.api.nvim_create_autocmd('User', {
                    once = true,
                    pattern = 'AlphaReady',
                    callback = function()
                        require('lazy').show()
                    end,
                })
            end

            require('alpha').setup(dashboard.opts)

            vim.api.nvim_create_autocmd('User', {
                once = true,
                pattern = 'LazyVimStarted',
                callback = function()
                    local stats = require('lazy').stats()
                    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                    local neovim_version = 'v' .. vim.version().major .. '.' .. vim.version().minor .. '.' .. vim.version().patch
                    local lazyvim_version = 'v' .. require('lazy.core.config').version
                    local footer = '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms'
                    local version = '      Neovim ' .. neovim_version .. ' · LazyVim ' .. lazyvim_version
                    dashboard.section.footer.val = { footer, '', version }
                    pcall(vim.cmd.AlphaRedraw)
                end,
            })
        end,
    },
}

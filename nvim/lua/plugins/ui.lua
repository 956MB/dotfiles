local Util = require 'lazyvim.util'

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
    { -- Icons
        'nvim-tree/nvim-web-devicons',
        enabled = true,
        config = function()
            require('nvim-web-devicons').setup()
        end,
    },

    { -- Notifications
        'rcarriga/nvim-notify',
        config = function()
            require('notify').setup {
                filter = function(_, win)
                    local bufnr = vim.api.nvim_win_get_buf(win)
                    local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
                    return buftype ~= 'help'
                end,
            }
        end,
    },

    { -- Integrated terminal
        'akinsho/toggleterm.nvim',
        version = '*',
        keys = {
            {
                '<C-\\>',
                '<cmd>ToggleTerm<CR>',
            },
        },
        config = function()
            require('toggleterm').setup {
                persist_mode = false,
                direction = 'float',
                float_opts = {
                    title_pos = 'center',
                },
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
            { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
        },
    },

    { -- Tabs
        'akinsho/bufferline.nvim',
        version = '*',
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = function(_, opts)
            opts.options = vim.tbl_deep_extend('force', opts.options, {
                indicator = {
                    icon = '┃ ', -- this should be omitted if indicator style is not 'icon'
                    style = 'icon',
                },
                always_show_bufferline = true,
                hover = {
                    enabled = true,
                    delay = 0,
                    reveal = { 'close' },
                },
                show_buffer_close_icons = true,
                diagnostics = 'nvim_lsp',
            })
        end,
    },

    { -- Statusline
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = function(_, opts)
            -- -- NOTE: Fixing github_dark_colorblind insert mode, something is override the green
            -- local insert_fix = require 'lualine.themes.github_dark_colorblind'
            -- insert_fix.insert.a.bg = '#10D01B' -- outer bg (1)
            -- insert_fix.insert.b.bg = '#1B3B16' -- middle bg (2)
            -- insert_fix.insert.b.fg = '#01B511' -- middle fg (2)
            -- insert_fix.insert.c.fg = '#0B8F23' -- inner fg (3)
            local function xcodebuild_device()
                if vim.g.xcodebuild_platform == 'macOS' then
                    return ' macOS'
                end
                if vim.g.xcodebuild_os then
                    return ' ' .. vim.g.xcodebuild_device_name .. ' (' .. vim.g.xcodebuild_os .. ')'
                end
                return ' ' .. vim.g.xcodebuild_device_name
            end

            -- opts.options.theme = insert_fix
            opts.options.disabled_filetypes = {
                statusline = {},
                winbar = {},
            }
            opts.sections.lualine_a = { 'mode' }
            opts.sections.lualine_c[4] = { lualine_pretty_path() }
            opts.sections.lualine_z = opts.sections.lualine_y
            opts.sections.lualine_y = opts.sections.lualine_x
            opts.sections.lualine_x = {
                { "' ' .. vim.g.xcodebuild_last_status", color = { fg = '#a6e3a1' } },
                { xcodebuild_device, color = { fg = '#f9e2af', bg = '#161622' } },
                'encoding',
                { 'g:metals_status' },
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

    { 'nvimdev/dashboard-nvim', optional = true, enabled = false },
    { 'echasnovski/mini.starter', optional = true, enabled = false },
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
			-- stylua: ignore
			dashboard.section.buttons.val = {
				{
					type = 'group',
					val = {
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
								return { theta.mru(0, cdir, 5) }
							end,
							opts = { shrink_margin = false },
						},
					},
				},
				{ type = 'padding', val = 1 },
				{ type = 'text', val = 'Quick links', opts = { hl = 'SpecialComment', position = 'center' } },
				{ type = 'padding', val = 1 },
                {
                    type = 'group',
                    val = {
                        dashboard.button('f', '󰱽 ' .. ' Find file',       '<cmd> Telescope find_files <CR>'),
                        dashboard.button('g', '󱩾 ' .. ' Find text',       '<cmd> Telescope live_grep <CR>'),
                        dashboard.button('n', ' ' .. ' New file',        '<cmd> ene <CR>'),
                        dashboard.button('r', ' ' .. ' Recent files',    '<cmd> Telescope oldfiles <CR>'),
                        dashboard.button('c', ' ' .. ' Config',          '<cmd> lua require("lazyvim.util").telescope.config_files()() <CR>'),
                        dashboard.button('s', '󰁯 ' .. ' Restore Session', '<cmd> lua require("persistence").load() <CR>'),
                        dashboard.button('u', ' ' .. ' Update plugins' , '<cmd> Lazy sync <CR>'),
                        dashboard.button('l', '󰒲 ' .. ' Lazy',            '<cmd> Lazy <CR>'),
                        dashboard.button('q', ' ' .. ' Quit',            '<cmd> qa <CR>'),
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
               .dP'                   db
             dP'                   db    db
                                            `Ybaaaaaad8'
  `Yb    dP'  'Yb   `Yb.d88b d88b    'Yb      .dP'   88  `Yb.d888b  `Yb    dP'
    Yb  dP     88    88'   8Y   8b    88      88     88   88'    8Y   Yb  dP
     YbdP      88    88    8P   88    88      Y8    .88   88     8P    YbdP
     .8P      .8P    88  ,dP  ,dP    .8P      `Y888P'88   88   ,dP     .8P
   dP'  b            88                              88   88         dP'  b
   Y.  ,P            88                              88   88         Y.  ,P
    `""'            .8P                              Y8. .8P          `""'

    ]]

            local neovim_version = 'v' .. vim.version().major .. '.' .. vim.version().minor .. '.' .. vim.version().patch
            local lazyvim_version = 'v' .. require('lazy.core.config').version

            local header = '\n\n\n\n\n\n' .. banner .. '\n' .. '                       Neovim ' .. neovim_version .. ' · LazyVim ' .. lazyvim_version
            dashboard.section.header.val = vim.split(header, '\n')

            dashboard.section.buttons.opts.hl = 'AlphaButtons'
            dashboard.section.buttons.opts.spacing = 0
            dashboard.section.footer.opts.hl = 'AlphaFooter'
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
                    dashboard.section.footer.val = '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms'
                    pcall(vim.cmd.AlphaRedraw)
                end,
            })
        end,
    },
}

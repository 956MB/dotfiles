local Util = require 'lazyvim.util'

-- like lazyvim.util.lualine.pretty_path but with a longer path (3 -> 6)
---@param opts? {relative: "cwd"|"root", modified_hl: string?}
local function lualine_pretty_path(opts)
    opts = vim.tbl_extend('force', {
        relative = 'cwd',
        modified_hl = 'Constant',
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
        keys = function()
            return {}
        end,
    },

    {
        'akinsho/bufferline.nvim',
        version = '*',
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = function(_, opts)
            opts.options = vim.tbl_deep_extend('force', opts.options, {
                indicator = {
                    icon = '┃', -- this should be omitted if indicator style is not 'icon'
                    style = 'icon',
                },
            })
        end,
    },

    { -- Lualine
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local lualine = require 'lualine'

            local function xcodebuild_device()
                if vim.g.xcodebuild_platform == 'macOS' then
                    return ' macOS'
                end

                if vim.g.xcodebuild_os then
                    return ' ' .. vim.g.xcodebuild_device_name .. ' (' .. vim.g.xcodebuild_os .. ')'
                end

                return ' ' .. vim.g.xcodebuild_device_name
            end

            -- NOTE: Fixing github_dark_colorblind insert mode, something is override the green
            -- local insert_fix = require 'lualine.themes.github_dark_colorblind'
            -- insert_fix.insert.a.bg = '#10D01B' -- outer bg (1)
            -- insert_fix.insert.b.bg = '#1B3B16' -- middle bg (2)
            -- insert_fix.insert.b.fg = '#01B511' -- middle fg (2)
            -- insert_fix.insert.c.fg = '#0B8F23' -- inner fg (3)

            lualine.setup {
                options = {
                    icons_enabled = true,
                    -- theme = insert_fix,
                    theme = 'auto',
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    },
                },
                sections = {
                    lualine_a = { 'mode' }, -- (1)
                    lualine_b = { 'branch', 'diff', 'diagnostics' }, -- (2)
                    -- lualine_c = { 'filename' }, -- (3)
                    lualine_c = { lualine_pretty_path() }, -- (3)
                    lualine_x = {
                        { "' ' .. vim.g.xcodebuild_last_status", color = { fg = '#a6e3a1' } },
                        { xcodebuild_device, color = { fg = '#f9e2af', bg = '#161622' } },
                        'encoding',
                        { 'fileformat', symbols = { unix = '' } },
                        'filetype',
                    },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { 'filename' },
                    lualine_x = { 'location' },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = { 'nvim-dap-ui', 'quickfix', 'trouble', 'nvim-tree', 'lazy', 'mason' },
            }
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

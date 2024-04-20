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
            local insert_fix = require 'lualine.themes.github_dark_colorblind'
            insert_fix.insert.a.bg = '#10D01B' -- outer bg (1)
            insert_fix.insert.b.bg = '#1B3B16' -- middle bg (2)
            insert_fix.insert.b.fg = '#01B511' -- middle fg (2)
            insert_fix.insert.c.fg = '#0B8F23' -- inner fg (3)

            lualine.setup {
                options = {
                    icons_enabled = true,
                    theme = insert_fix,
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
                    lualine_c = { 'filename' }, -- (3)
                    lualine_x = {
                        { "' ' .. vim.g.xcodebuild_last_status", color = { fg = '#a6e3a1' } },
                        -- { "'󰙨 ' .. vim.g.xcodebuild_test_plan", color = { fg = "#a6e3a1", bg = "#161622" } },
                        { xcodebuild_device, color = { fg = '#f9e2af', bg = '#161622' } },
                        'encoding',
                        'fileformat',
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

    { -- Dashboard
        'nvimdev/dashboard-nvim',
        opts = function(_, opts)
            local neovim_version = 'v' .. vim.version().major .. '.' .. vim.version().minor .. '.' .. vim.version().patch
            local lazyvim_version = 'v' .. require('lazy.core.config').version

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
            local versions = 'Neovim ' .. neovim_version .. ' · LazyVim ' .. lazyvim_version
            banner = banner .. '\n' .. versions .. '\n\n'
            banner = string.rep('\n', 8) .. banner
            opts.config.header = vim.split(banner, '\n')
        end,
    },
}

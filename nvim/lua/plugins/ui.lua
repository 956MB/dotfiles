return {
    { -- Notifications
        'rcarriga/nvim-notify',
        keys = function()
            return {}
        end,
    },

    { -- Lualine
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                icons_enabled = true,
                theme = 'habamax',
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
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = { 'filename' },
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
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
            extensions = {},
        },
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

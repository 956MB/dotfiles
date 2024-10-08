-- Database plugins
--
return {
    { -- Database client
        'kristijanhusak/vim-dadbod-ui',
        dependencies = {
            { 'tpope/vim-dadbod', lazy = true },
            { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql', 'sqlite' }, lazy = true },
        },
        cmd = {
            'DBUI',
            'DBUIToggle',
            'DBUIAddConnection',
            'DBUIFindBuffer',
        },
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_winwidth = 50
            vim.g.db_ui_use_nvim_notify = 1
            vim.g.db_ui_show_help = 1 -- Show help when starting
        end,
    },

    -- { -- Yank history
    --     'ptdewey/yankbank-nvim',
    --     dependencies = 'kkharji/sqlite.lua',
    --     config = function()
    --         require('yankbank').setup {
    --             persist_type = 'sqlite',
    --         }
    --     end,
    -- },
}

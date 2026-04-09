-- All plugins in this file are local forks added to rtp in pack.lua.

-- [[ ncks.nvim: nicknames ]]
require('ncks').setup {
    new_nickname = { prompt_title = 'New' },
    search = { prompt_title = 'Search' },
}

-- [[ oil.nvim: file explorer ]]
require('oil').setup {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    constrain_cursor = 'name',
    win_options = {
        signcolumn = 'yes:1',
        wrap = true,
    },
    keymaps = {
        ['-'] = false,
        ['<BS>'] = 'actions.parent',
    },
    view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
            return name:match '^%.DS_Store$'
        end,
    },
}

-- [[ yazi.nvim ]]
require('yazi').setup {
    size = {
        width = 1.0,
        height = 0.25,
    },
    direction = 'horizontal',
    close_on_exit = false,
}

-- [[ todo-comments.nvim ]]
require('todo-comments').setup {
    signs = false,
    keywords = {
        MINE = { icon = ' ', color = 'mine' },
    },
    highlight = {
        keyword = 'wide_fg',
    },
    colors = {
        mine = { fg = '#ff0000', bg = '#000000', gui = 'bold' },
    },
}

-- [[ quicker.nvim: better quickfix ]]
require('quicker').setup {
    highlight = {
        cursor_linenr = {
            show = true,
            debounce = 15,
        },
    },
    borders = {
        vert = '┊',
        strong_header = '┄',
        strong_cross = '┼',
        strong_end = '┤',
        soft_header = '┄',
        soft_cross = '┼',
        soft_end = '┤',
    },
    keys = {
        {
            '>',
            function()
                require('quicker').expand { before = 2, after = 2, add_to_existing = true }
            end,
            desc = 'Expand quickfix context',
        },
        {
            '<',
            function()
                require('quicker').collapse()
            end,
            desc = 'Collapse quickfix context',
        },
    },
}

-- [[ head.nvim: custom file header ]]
vim.opt.runtimepath:append '~/dotfiles/nvim/lua/plugins/custom/head.nvim'
require('head').setup()

vim.api.nvim_create_user_command('HeadReload', function()
    for k in pairs(package.loaded) do
        if k:match '^head' then
            package.loaded[k] = nil
        end
    end
    require('head').setup()
    print 'head.nvim reloaded!'
end, {})

return {
    { -- Nicknames
        -- '956MB/ncks.nvim',
        dir = '~/dotfiles/nvim/lua/plugins/custom/ncks.nvim',
        dependencies = {
            { 'nvim-telescope/telescope.nvim' },
        },
        config = function()
            require('ncks').setup {
                new_nickname = {
                    prompt_title = 'New',
                },
                search = {
                    prompt_title = 'Search',
                },
            }
        end,
    },

    { -- OIL
        -- 'stevearc/oil.nvim',
        dir = '~/dotfiles/nvim/lua/plugins/custom/oil.nvim',
        name = 'oil.nvim',
        dependencies = {
            { 'nvim-tree/nvim-web-devicons' },
        },
        config = function()
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
                    ['<BS>'] = 'actions.parent', -- changed to backspace
                },
                view_options = {
                    show_hidden = true,
                    is_always_hidden = function(name, _)
                        return name.match(name, '^%.DS_Store$')
                    end,
                },
            }
        end,
    },
    { -- Git status oil.nvim
        'refractalize/oil-git-status.nvim',
        dependencies = {
            'oil.nvim',
        },
        config = function()
            require('oil-git-status').setup {
                show_ignored = false,
            }
        end,
    },

    {
        'mikavilpas/yazi.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        config = function()
            require('yazi').setup {
                -- Size of the Yazi window
                size = {
                    width = 1.0, -- 80% of window width
                    height = 0.25, -- 70% of window height
                },
                -- Open in a horizontal split (for your requirement)
                direction = 'horizontal',
                -- Keep Yazi open when selecting files
                close_on_exit = false,
            }
        end,
    },

    { -- Highlight todo, notes, etc in comments
        -- 'folke/todo-comments.nvim',
        dir = '~/dotfiles/nvim/lua/plugins/custom/todo-comments.nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local c = require('vscode.colors').get_colors()
            require('todo-comments').setup {
                signs = false,
                keywords = {
                    MINE = { icon = ' ', color = 'mine' },
                },
                highlight = {
                    keyword = 'wide_fg',
                },
                colors = {
                    mine = { c.lualineYellow },
                },
            }
        end,
    },

    { -- Better quickfix window
        -- 'stevearc/quicker.nvim',
        dir = '~/dotfiles/nvim/lua/plugins/custom/quicker.nvim',
        branch = 'QuickFixCursorLineNr',
        event = 'FileType qf',
        config = function()
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
        end,
    },

    -- { -- Bookmarks
    --     -- 'tristone13th/lspmark.nvim',
    --     dir = '~/dotfiles/nvim/lua/plugins/custom/lspmark.nvim',
    --     config = function()
    --         require('lspmark').setup()
    --         require('telescope').load_extension 'lspmark'
    --     end,
    -- },

    { -- Custom header
        dir = '~/dotfiles/nvim/lua/plugins/custom/head.nvim',
        -- name = 'head',
        -- dev = true,
        -- build = ':helptags ALL',
        config = function()
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
        end,
    },
}

return {
    -- { -- Icons
    --     'nvim-tree/nvim-web-devicons',
    --     lazy = true,
    --     config = function()
    --         require('nvim-web-devicons').setup {
    --             default = true,
    --             color_icons = true,
    --             strict = true,
    --         }
    --     end,
    -- },

    { -- Fixing gx with OIL
        'chrishrb/gx.nvim',
        keys = { { 'gx', '<cmd>Browse<cr>', mode = { 'n', 'v' } } },
        cmd = { 'Browse' },
        init = function()
            vim.g.netrw_nogx = 1 -- disable netrw gx
        end,
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
        },
        config = true,
        submodules = false,
    },

    { -- File tree
        'nvim-tree/nvim-tree.lua',
        cmd = { 'NvimTreeToggle', 'NvimTreeOpen' },
        version = '*',
        -- lazy = false,
        dependencies = {
            -- 'nvim-tree/nvim-web-devicons',
            'antosha417/nvim-lsp-file-operations',
            'nvim-mini/mini.base16',
        },
        config = function()
            local function shorten_path(path, max_length)
                path = vim.fn.fnamemodify(path, ':~')

                local parts = vim.split(path, '/')
                local left = 1
                local right = #parts

                while #table.concat(parts, '/') > max_length and left < right - 1 do
                    for i = right - 1, left + 1, -1 do
                        if #parts[i] > 1 then
                            parts[i] = string.sub(parts[i], 1, 1)
                            break
                        end
                    end
                end

                return table.concat(parts, '/')
            end

            require('nvim-tree').setup {
                view = {
                    width = 40,
                    side = 'right',
                },
                renderer = {
                    root_folder_label = function(path)
                        return shorten_path(path, 35)
                    end,
                    icons = {
                        glyphs = {
                            git = {
                                unstaged = '~',
                                staged = '+',
                                unmerged = 'x',
                                renamed = '>',
                                untracked = '?',
                                deleted = '-',
                                ignored = '!',
                            },
                        },
                        show = {
                            file = true,
                            folder = true,
                            folder_arrow = true,
                            git = false,
                            modified = false,
                            diagnostics = false,
                            bookmarks = false,
                        },
                    },
                },
                filters = {
                    custom = { '.DS_Store' },
                    git_ignored = false,
                },
                update_focused_file = {
                    enable = true,
                    update_root = false,
                    ignore_list = {},
                },
            }
        end,
    },
}

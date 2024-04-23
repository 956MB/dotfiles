return {
    { -- Markdown live preview
        'iamcco/markdown-preview.nvim',
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        ft = { 'markdown' },
        build = function()
            vim.fn['mkdp#util#install']()
        end,
    },

    { -- Obsidian integration
        'epwalsh/obsidian.nvim',
        version = '*',
        lazy = true,
        ft = 'markdown',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
        },
        opts = {
            workspaces = {
                {
                    name = 'ObsidianVault',
                    path = '~/Documents/Obsidian Vault',
                },
            },
            mappings = {},
        },
    },

    { -- Nicknames
        -- '956MB/ncks.nvim',
        dir = '~/dotfiles/nvim/lua/plugins/custom/ncks.nvim',
        config = function()
            local ncks = require 'ncks'
            ncks.setup {
                -- location = '~/.ncksNOT',
            } -- requried

            local function toggle_telescope(contents)
                local function handle_input(prompt_bufnr)
                    local entry = require('telescope.actions.state').get_current_line()
                    if entry and entry ~= '' then
                        require('telescope.actions').close(prompt_bufnr)
                        ncks.write(entry)
                    end
                end

                require('telescope.pickers')
                    .new({
                        prompt_title = ncks.config.prompt_title,
                        results_title = ncks.config.location,
                        finder = require('telescope.finders').new_table {
                            results = contents,
                            entry_maker = function(entry)
                                return {
                                    value = entry,
                                    display = entry,
                                    ordinal = entry,
                                }
                            end,
                        },
                        layout_config = ncks.config.layout_config,
                        sorting_strategy = 'ascending',
                        attach_mappings = function(prompt_bufnr, map)
                            map('i', '<CR>', function()
                                handle_input(prompt_bufnr)
                            end)
                            map('n', '<CR>', function() end)
                            return true
                        end,
                    }, {})
                    :find()
            end

            vim.keymap.set('n', '<leader>nn', function()
                ncks.exists(function(_)
                    toggle_telescope(ncks.list())
                end)
            end, { desc = 'Add [N]ew [N]ick (Telescope)' })
        end,
    },
}

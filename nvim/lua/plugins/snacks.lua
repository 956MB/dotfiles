local logo_path = vim.fn.expand '~' .. '/dotfiles/logos/logo-52b.txt'
local logo = table.concat(vim.fn.readfile(logo_path), '\n') .. '\n'

require('snacks').setup {
    bigfile = {},
    bufdelete = {},
    dashboard = {
        formats = {
            key = function(item)
                return { { '[', hl = 'NonText' }, { item.key, hl = 'Normal' }, { ']', hl = 'NonText' } }
            end,
            header = { '%s', align = 'center', hl = 'Normal' },
            icon = function(item)
                if item.file and item.icon == 'file' or item.icon == 'directory' then
                    return { '' }
                end
                return { item.icon, width = 2, hl = 'Normal' }
            end,
            file = function(item, ctx)
                local fname = vim.fn.fnamemodify(item.file, ':~')
                fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
                if #fname > ctx.width then
                    local dir = vim.fn.fnamemodify(fname, ':h')
                    local file = vim.fn.fnamemodify(fname, ':t')
                    if dir and file then
                        file = file:sub(-(ctx.width - #dir - 2))
                        fname = dir .. '/…' .. file
                    end
                end
                local dir, file = fname:match '^(.*)/(.+)$'
                local icon, icon_hl = '', ''
                if file and file:match '%.' then
                    local ok
                    ok, icon, icon_hl = pcall(require('mini.icons').get, 'file', file)
                    if not ok then
                        icon, icon_hl = '', ''
                    end
                end
                return dir
                        and {
                            { dir .. ' ', hl = 'dir' },
                            icon ~= '' and { icon .. ' ', hl = icon_hl } or { '' },
                            { file, hl = 'file' },
                        }
                    or { { fname, hl = 'file' } }
            end,
        },
        preset = {
            keys = {
                -- stylua: ignore start
                { icon = "  ", key = "f", desc = "find file", action = ":lua Snacks.dashboard.pick('files', { hidden = true })" },
                { icon = "  ", key = "w", desc = "find text", action = ":lua Snacks.dashboard.pick('live_grep', { hidden = true })" },
                { icon = "  ", key = "e", desc = "explorer", action = ":lua require('oil').toggle_float()" },
                { icon = " 󰁯 ", key = "s", desc = "restore session", action = ":lua require('persistence').load()" },
                { icon = " 󰒲 ", key = "p", desc = "pack update", action = ":lua vim.pack.update()" },
                { icon = " 󰭿 ", key = "q", desc = "quit", action = ":qa" },
                -- stylua: ignore end
            },
        },
        sections = {
            -- stylua: ignore start
            { header = { { logo, hl = "NonText" } }, align = "center" },
            { header = { { "956MB ", hl = "NonText" }, { "- self-taught generalist, unfortunately.", hl = "Normal" } }, padding = 1, align = "center" },
            { section = "keys", padding = 1 },
            { title = " mru ", file = vim.fn.fnamemodify(".", ":~") },
            { section = "recent_files", cwd = true, limit = 6, padding = 1 },
            { padding = 16 },
            -- stylua: ignore end
        },
    },
    git = {},
    indent = {
        indent = {
            enabled = false,
        },
        animate = {
            enabled = false,
        },
        scope = {
            treesitter = {
                enabled = true,
            },
        },
    },
    image = {
        doc = {
            inline = false,
            max_height = 12,
            max_width = 24,
        },
    },
    scroll = { enabled = false },
    statuscolumn = {},
    rename = {},
    terminal = {},
    picker = {
        ui_select = false,
        layout = {
            preset = 'minimal',
        },
        layouts = {
            minimal = {
                preview = false,
                layout = {
                    backdrop = false,
                    height = 0.25,
                    width = 0.4,
                    box = 'horizontal',
                    {
                        border = 'single',
                        box = 'vertical',
                        title = '{title}',
                        title_pos = 'left',
                        { win = 'input', height = 1, border = 'bottom' },
                        { win = 'list', border = 'none' },
                    },
                    { win = 'preview', title = '{preview}', title_pos = 'left', border = 'single' },
                },
            },
        },
        sources = {
            grep = {
                layout = {
                    preview = true,
                },
            },
            icons = {
                layout = {
                    preset = 'minimal',
                },
            },
        },
    },
    input = { enabled = true },
    styles = {
        input = {
            border = 'single',
            relative = 'cursor',
            title = '',
        },
        snacks_image = {
            relative = 'editor',
            border = 'none',
            focusable = false,
            backdrop = false,
            row = 1,
            col = -1,
        },
        blame_line = {
            border = 'single',
            title = 'git blame',
        },
    },
}

-- Snacks keymaps
local map = vim.keymap.set
-- stylua: ignore start
map('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'delete buffer' })
map('n', '<leader>gb', function() Snacks.git.blame_line() end, { desc = 'blame line' })
map('n', '<leader>cR', function() Snacks.rename() end, { desc = 'rename file' })
map('n', '<leader>fn', function() Snacks.notifier.show_history() end, { desc = 'notification history' })
map('n', '<leader>fs', function() Snacks.picker.smart() end, { desc = 'smart files' })
map('n', '<leader>ff', function() Snacks.picker.files({ hidden = true }) end, { desc = 'find files' })
map('n', '<leader>fw', function() Snacks.picker.grep({ hidden = true }) end, { desc = 'live grep' })
map('x', '<leader>fw', function() Snacks.picker.grep_word() end, { desc = 'grep selection' })
map('n', '<leader>fi', function() Snacks.picker.icons() end, { desc = 'icons' })
map('n', '<leader>hl', '<cmd>Telescope highlights<CR>', { desc = 'show highlights' })
-- stylua: ignore end

-- VeryLazy: setup debug globals and toggles after startup
vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
        _G.dd = function(...)
            Snacks.debug.inspect(...)
        end
        _G.bt = function()
            Snacks.debug.backtrace()
        end
        vim.print = _G.dd

        Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>tw'
        Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>tC'
        Snacks.toggle.inlay_hints():map '<leader>th'
        Snacks.toggle.indent():map '<leader>tg'
        Snacks.toggle.dim():map '<leader>tD'
    end,
})

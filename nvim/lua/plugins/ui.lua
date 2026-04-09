local cfg_utils = require 'config.utils'

-- Standalone path display for lualine (replaces lazyvim.util dependency)
local function lualine_pretty_path()
    return function()
        local path = vim.fn.expand '%:p' --[[@as string]]
        if path == '' then return '' end

        local cwd = vim.fn.getcwd()
        if path:find(cwd, 1, true) == 1 then
            path = path:sub(#cwd + 2)
        end

        local sep = package.config:sub(1, 1)
        local parts = vim.split(path, '[\\/]')
        if #parts > 6 then
            parts = { parts[1], parts[2], parts[3], parts[4], '…', parts[#parts - 1], parts[#parts] }
        end

        if vim.bo.modified then
            parts[#parts] = parts[#parts] .. ' ●'
        end

        return table.concat(parts, sep)
    end
end

local function inactive_statusline()
    local width = vim.fn.winwidth(0)
    local filename = vim.fn.expand '%:t'
    local position = string.format('%d:%d', vim.fn.line '.', vim.fn.col '.')
    local backslash_count = width - #filename - #position - 4
    local backslashes = string.rep('\\', backslash_count)
    return string.format('%s %s %s', filename, backslashes, position)
end

-- [[ nvim-notify ]]
require('notify').setup {
    filter = function(_, win)
        local bufnr = vim.api.nvim_win_get_buf(win)
        local buftype = vim.api.nvim_get_option_value('buftype', { buf = bufnr })
        return buftype ~= 'help'
    end,
}

-- [[ noice.nvim ]]
require('noice').setup {
    lsp = {
        override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
        },
    },
    presets = {
        bottom_search = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
    },
    views = {
        cmdline_popup = {
            position = {
                row = '50%',
                col = '50%',
            },
            win_options = {
                winhighlight = {
                    Normal = 'NoiceCmdlineNormal',
                    FloatBorder = 'NoiceCmdlinePopupBorder',
                    FloatTitle = 'NoiceCmdlinePopupTitle',
                },
            },
        },
    },
}

-- [[ lualine ]]
require('lualine').setup {
    options = {
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = { 'NvimTree' },
            winbar = {},
        },
        always_divide_middle = true,
        globalstatus = false,
        ignore_focus = {},
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { lualine_pretty_path() },
        lualine_x = {
            { "' ' .. vim.g.xcodebuild_last_status", color = { fg = '#a6e3a1' } },
            'encoding',
            { 'g:metals_status' },
        },
        lualine_y = { 'filetype' },
        lualine_z = { 'location' },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { inactive_statusline },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = { 'quickfix', 'trouble', 'nvim-tree', 'mason' },
}

-- [[ bufferline ]]
local bufferline = require 'bufferline'
local bufferline_opts = {
    options = {
        indicator = {
            icon = '┃',
            style = 'icon',
        },
        show_buffer_close_icons = false,
        always_show_bufferline = false,
        hover = {
            enabled = true,
            delay = 0,
            reveal = { 'close' },
        },
        diagnostics = 'nvim_lsp',
        color_icons = true,
        show_buffer_icons = true,
    },
}
bufferline.setup(bufferline_opts)

local bufferline_visible = true
_G.toggle_bufferline = function()
    bufferline_visible = not bufferline_visible
    if bufferline_visible then
        vim.opt.showtabline = 1
        bufferline.setup(bufferline_opts)
    else
        vim.opt.showtabline = 0
    end
end
vim.api.nvim_create_user_command('ToggleBufferline', 'lua _G.toggle_bufferline()', {})
vim.keymap.set('n', '<leader>tb', '<cmd>lua _G.toggle_bufferline()<CR>', { noremap = true, silent = true, desc = 'Toggle bufferline visibility' })

-- [[ ccc.nvim: color preview ]]
require('ccc').setup {
    highlighter = {
        auto_enable = true,
        lsp = true,
        filetypes = {
            'html', 'lua', 'css', 'scss', 'sass', 'less', 'stylus',
            'javascript', 'tmux', 'typescript', 'conf', 'toml', 'yaml',
        },
        excludes = { 'mason', 'help', 'neo-tree' },
    },
}

-- [[ visual-whitespace.nvim ]]
require('visual-whitespace').setup()

-- [[ toggleterm ]]
require('toggleterm').setup {
    persist_mode = true,
    size = function(term)
        if term.direction == 'horizontal' then
            return 20
        elseif term.direction == 'vertical' then
            return vim.o.columns * 0.4
        end
    end,
    float_opts = {
        border = 'curved',
        title_pos = 'center',
    },
    on_open = function(term)
        vim.api.nvim_set_option_value('winhighlight', 'Normal:Normal', { win = term.window })

        local opts = { buffer = term.bufnr }
        vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-W>k]], opts)
        vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-W>j]], opts)
        vim.keymap.set('t', '<C-S-j>', [[<C-\><C-n><C-W>h]], opts)
        vim.keymap.set('t', '<C-S-k>', [[<C-\><C-n><C-W>l]], opts)

        vim.keymap.set('t', '<C-,>', function()
            vim.cmd.stopinsert()
            cfg_utils.scale_split '-1'
            vim.cmd.startinsert()
        end, opts)
        vim.keymap.set('t', '<C-.>', function()
            vim.cmd.stopinsert()
            cfg_utils.scale_split '+1'
            vim.cmd.startinsert()
        end, opts)

        vim.cmd 'autocmd BufEnter <buffer> startinsert'
    end,
}

vim.keymap.set('n', '<C-\\>', '<cmd>ToggleTerm direction=float<CR>', { desc = '[T]oggleTerm [F]loat' })
vim.keymap.set('n', '<leader>vt', '<cmd>ToggleTerm direction=vertical<CR>', { desc = '[T]oggleTerm [V]ertical' })
vim.keymap.set('n', '<leader>ht', '<cmd>ToggleTerm direction=horizontal<CR>', { desc = '[T]oggleTerm [H]orizontal' })

-- [[ smart-splits ]]
require('smart-splits').setup {
    default_amount = 1,
}

-- [[ force-cul ]]
require('force-cul').setup()

-- [[ lazygit ]]
vim.g.lazygit_floating_window_use_plenary = 0
vim.keymap.set('n', '<leader>lg', cfg_utils.open_lazygit_tab, { desc = 'LazyGit in Buffer' })

-- [[ vgit ]]
require('vgit').setup {
    settings = {
        live_blame = { enabled = false },
    },
}

-- [[ persistence ]]
require('persistence').setup { autoload = false }

-- [[ cheatsheet ]]
-- No setup needed; accessed via <leader>ch keymap.

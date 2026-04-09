-- [[ nvim-ufo: folding ]]
local ufo_handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (' 󰁂 %d '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, 'UfoSuffixHighlight' })
    return newVirtText
end

require('ufo').setup {
    fold_virt_text_handler = ufo_handler,
    provider_selector = function(_, _, _)
        return { 'treesitter', 'indent' }
    end,
}

-- [[ neotest ]]
require('neotest').setup {
    adapters = {
        require 'neotest-rust',
    },
}

vim.keymap.set('n', '<leader>tt', function()
    require('neotest').run.run()
end, { desc = 'Run nearest test' })
vim.keymap.set('n', '<leader>tf', function()
    require('neotest').run.run(vim.fn.expand '%')
end, { desc = 'Run file tests' })
vim.keymap.set('n', '<leader>ts', function()
    require('neotest').summary.toggle()
end, { desc = 'Toggle test summary' })

-- [[ conform.nvim: formatting ]]
require('conform').setup {
    notify_on_error = false,
    format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
    },
    formatters_by_ft = {
        rust = { 'rustfmt' },
        css = { 'prettierd', 'prettier' },
        lua = { 'stylua' },
        go = { 'goimports', 'gofmt' },
        python = { 'black' },
    },
    formatters = {
        black = {
            prepend_args = { '--line-length', '88', '--fast' },
        },
    },
}

vim.keymap.set('', '<leader>f', function()
    require('conform').format { async = true, lsp_fallback = true }
end, { desc = '[F]ormat buffer' })

-- [[ mini.ai + mini.surround ]]
require('mini.ai').setup { n_lines = 500 }
require('mini.surround').setup()

-- [[ mini.indentscope ]]
require('mini.indentscope').setup {
    symbol = '│',
    draw = {
        delay = 0,
        animation = require('mini.indentscope').gen_animation.none(),
    },
}

-- [[ copilot ]]
-- Loaded on InsertEnter to avoid startup cost.
vim.api.nvim_create_autocmd('InsertEnter', {
    once = true,
    callback = function()
        require('copilot').setup {
            panel = {
                enabled = true,
                auto_refresh = false,
                keymap = {
                    jump_prev = '[[',
                    jump_next = ']]',
                    accept = '<CR>',
                    refresh = 'gr',
                    open = '<M-CR>',
                },
                layout = { position = 'bottom', ratio = 0.4 },
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                debounce = 75,
                keymap = {
                    accept = '<C-CR>',
                    accept_word = false,
                    accept_line = false,
                    next = '<M-]>',
                    prev = '<M-[>',
                    dismiss = '<C-]>',
                },
            },
            filetypes = {
                yaml = false,
                markdown = true,
                help = false,
                gitcommit = false,
                gitrebase = false,
                ['*'] = true,
            },
            copilot_node_command = vim.fn.exepath 'node',
            server_opts_overrides = {},
        }
    end,
})

-- [[ opencode.nvim ]]
vim.o.autoread = true
local function set_opencode_keymaps()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname:match 'opencode' then
        local opts = { buffer = true, silent = true }
        vim.keymap.set('t', '<C-j>', function()
            vim.cmd 'stopinsert'
            require('smart-splits').move_cursor_left()
        end, opts)
        vim.keymap.set('t', '<C-k>', function()
            vim.cmd 'stopinsert'
            require('smart-splits').move_cursor_right()
        end, opts)
        vim.keymap.set('t', '<C-S-k>', function()
            vim.cmd 'stopinsert'
            require('smart-splits').move_cursor_down()
        end, opts)
        vim.keymap.set('t', '<C-S-j>', function()
            vim.cmd 'stopinsert'
            require('smart-splits').move_cursor_up()
        end, opts)
    end
end
vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter' }, {
    pattern = '*',
    callback = set_opencode_keymaps,
})

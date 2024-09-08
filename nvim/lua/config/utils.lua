local M = {}

-- Scale split size
function M.scale_split(direction)
    local current_window = vim.api.nvim_get_current_win()
    local current_window_height = vim.api.nvim_win_get_height(current_window)
    local current_window_width = vim.api.nvim_win_get_width(current_window)

    if current_window_width and current_window_height then
        local vertical = current_window_width > current_window_height and '' or 'vertical '
        vim.cmd(vertical .. 'resize ' .. direction)
    end
end

-- Toggle conceal level and spell checking (for Markdown files)
function M.toggle_markdown_display()
    local conceallevel = vim.wo.conceallevel
    if conceallevel == 0 then
        vim.wo.conceallevel = 2
    else
        vim.wo.conceallevel = 0
    end

    local spell = vim.wo.spell
    vim.wo.spell = not spell
end

-- Toggle relative line numbers
function M.surround_and_capitalize()
    local word = vim.fn.expand '<cword>'
    local modified = '[' .. word:sub(1, 1):upper() .. ']' .. word:sub(2)
    vim.cmd('normal! ciw' .. modified)
end

-- Scroll screen up/down less than full 100%
function M.scroll_less_screen(direction)
    local win_height = vim.fn.winheight(0)
    local scroll_amount = math.floor(win_height / 4)
    if direction == 'down' then
        vim.cmd('normal! ' .. scroll_amount .. 'jzt')
    else
        vim.cmd('normal! ' .. scroll_amount .. 'kzb')
    end
end

-- Open `lazygit` in new tab instead of floating window
function M.open_lazygit_tab()
    local api = vim.api

    local buf = api.nvim_create_buf(false, true)
    api.nvim_command 'tab split'
    local win = api.nvim_get_current_win()
    api.nvim_win_set_buf(win, buf)
    api.nvim_buf_set_name(buf, 'LazyGit')
    api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    api.nvim_win_set_option(win, 'number', false)
    api.nvim_win_set_option(win, 'relativenumber', false)
    api.nvim_win_set_option(win, 'signcolumn', 'no')

    local _ = vim.fn.termopen('lazygit', {
        on_exit = function(_)
            vim.schedule(function()
                api.nvim_command 'tabclose'
            end)
        end,
    })

    -- api.nvim_buf_set_keymap(buf, 't', 'q', '<C-\\><C-n>:q<CR>', { noremap = true, silent = true })

    vim.cmd 'startinsert'
end

return M

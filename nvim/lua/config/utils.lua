local M = {}

-- Insert text without moving the cursor
function M.insert_without_moving(before_cursor)
    if before_cursor == nil then
        before_cursor = true
    end

    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_get_current_line()
    local col = cursor_pos[2]

    -- Save the current value of 'virtualedit'
    local ve_save = vim.o.virtualedit

    -- Set 'virtualedit' to 'onemore' to allow the cursor to be placed between characters
    vim.o.virtualedit = 'onemore'

    if before_cursor and col > 0 and col <= #line then
        vim.api.nvim_feedkeys('i', 'n', false)
    elseif not before_cursor and col >= 0 and col < #line then
        vim.api.nvim_feedkeys('a', 'n', false)
    else
        vim.api.nvim_feedkeys('i', 'n', false)
    end

    -- Create an autocmd to restore the 'virtualedit' option when exiting insert mode
    local group_id = vim.api.nvim_create_augroup('RestoreVirtualedit', { clear = true })
    vim.api.nvim_create_autocmd('InsertLeave', {
        group = group_id,
        callback = function()
            vim.o.virtualedit = ve_save
            vim.api.nvim_del_augroup_by_id(group_id)
        end,
        once = true,
    })
end

-- Loop around tabs
function M.tab_loop(direction)
    local tab_count = vim.tbl_count(vim.api.nvim_list_tabpages())
    local current_tab = vim.api.nvim_tabpage_get_number(0)

    if direction == 'next' then
        if current_tab == tab_count then
            vim.cmd 'tabn 1'
        else
            vim.cmd 'tabnext'
        end
    elseif direction == 'prev' then
        if current_tab == 1 then
            vim.cmd('tabn ' .. tab_count)
        else
            vim.cmd 'tabprevious'
        end
    end
end

-- Move cursor to the beginning or end of the line if it's the first or last line
function M.move_cursor_to_line_edge()
    local line = vim.fn.line '.'
    local total_lines = vim.fn.line '$'

    if line == 1 then
        vim.cmd 'normal! 0' -- Move cursor to the beginning of the first line
    elseif line == total_lines then
        vim.cmd 'normal! $' -- Move cursor to the end of the last line
    end
end

function M.close_neo_tree()
    if package.loaded['neo-tree'] then
        require('neo-tree.command').execute { toggle = true }
    end
end

return M

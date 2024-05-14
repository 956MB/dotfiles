local M = {}

function M.scale_split(direction)
    local current_window = vim.api.nvim_get_current_win()
    local current_window_height = vim.api.nvim_win_get_height(current_window)
    local current_window_width = vim.api.nvim_win_get_width(current_window)

    if current_window_width and current_window_height then
        local vertical = current_window_width > current_window_height and '' or 'vertical '
        vim.cmd(vertical .. 'resize ' .. direction)
    end
end

-- Function to toggle conceal level and spell checking (for Markdown files)
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

return M

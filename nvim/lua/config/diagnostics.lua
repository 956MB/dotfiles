vim.diagnostic.config {
    virtual_text = true,
    virtual_lines = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = 'rounded',
    },
}

-- This is needed to ensure virtual_lines is disabled
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*',
    callback = function()
        vim.diagnostic.config {
            virtual_lines = false,
            virtual_text = true,
            underline = true,
        }
    end,
})

return {}

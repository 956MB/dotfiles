-- Fix bugged git change symbol
local function override_highlights()
    vim.api.nvim_set_hl(0, 'GitSignsChange', { bg = 'none', fg = '#E48256' })
end

return {
    { -- Color scheme
        'ntk148v/habamax.nvim',
        priority = 1000,
        config = function()
            override_highlights() -- Call the highlight override function
        end,
    },
}

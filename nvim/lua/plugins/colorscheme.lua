-- Fix bugged git change symbol
local function override_highlights()
    vim.api.nvim_set_hl(0, 'GitSignsChange', { bg = 'none', fg = '#E48256' })
end

return {
    { -- Color scheme
        'projekt0n/github-nvim-theme', -- nt148v/habamax.nvim, nyoom-engineering/oxocarbon.nvim, projekt0n/github-nvim-theme
        lazy = false,
        priority = 1000,
        config = function()
            override_highlights() -- Call the highlight override function
        end,
    },
}

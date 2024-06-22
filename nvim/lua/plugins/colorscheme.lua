-- Fix bugged git change symbol
local function override_highlights()
    -- vim.api.nvim_set_hl(0, 'GitSignsChange', { bg = 'none', fg = '#E48256' })

    -- -- Override Comment highlight to a lighter color for better visibility
    -- vim.api.nvim_set_hl(0, 'Comment', { fg = '#ff0000', bg = 'none', italic = true })
    -- -- Override IndentBlanklineChar highlight to a different grey color
    -- vim.api.nvim_set_hl(0, 'IndentBlanklineChar', { fg = '#505050', bg = 'none' })
end

return {
    { 'fladson/vim-kitty' },
    -- ntk148v/habamax.nvim
    -- nyoom-engineering/oxocarbon.nvim
    -- projekt0n/github-nvim-theme
    -- luisiacc/gruvbox-baby
    -- bradcush/nvim-base16
    -- blazkowolf/gruber-darker.nvim
    -- olivercederborg/poimandres.nvim
    -- elvessousa/sobrio
    { -- Color scheme
        -- 'nyoom-engineering/oxocarbon.nvim',
        dir = '~/dotfiles/nvim/lua/plugins/custom/sobrio',
        -- lazy = false,
        priority = 1000,
        config = function()
            override_highlights() -- Call the highlight override function
        end,
    },
}

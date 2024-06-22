-- local colors = require('gruvbox-baby.colors').config()
-- vim.g.gruvbox_baby_highlights = { Normal = { guifg = colors.fg, guibg = colors.dark0 } }

return {
    { -- Plugin: LazyVim
        'LazyVim/LazyVim',
        opts = {
            -- habamax
            -- oxocarbon
            -- github_dark_colorblind
            -- base16-default-dark
            -- gruber-darker
            -- poimandres
            -- sobrio
            colorscheme = 'sobrio',
            defaults = {
                autocmds = true, -- lazyvim.config.autocmds
                keymaps = false, -- lazyvim.config.keymaps
                options = true, -- lazyvim.config.options
            },
        },
    },
}

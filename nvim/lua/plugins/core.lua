return {
    { -- Plugin: LazyVim
        'LazyVim/LazyVim',
        opts = {
            colorscheme = 'github_dark_colorblind', -- habamax, oxocarbon, github_dark_colorblind
            defaults = {
                autocmds = true, -- lazyvim.config.autocmds
                keymaps = false, -- lazyvim.config.keymaps
                options = true, -- lazyvim.config.options
            },
        },
    },
}

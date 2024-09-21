return {
    { -- Plugin: LazyVim
        'LazyVim/LazyVim',
        opts = {
            colorscheme = 'vscode',
            defaults = {
                autocmds = true, -- lazyvim.config.autocmds
                keymaps = false, -- lazyvim.config.keymaps
                options = true, -- lazyvim.config.options
            },
        },
    },
}

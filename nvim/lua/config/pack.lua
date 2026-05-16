-- [[ vim.pack plugin manager ]]
-- Neovim 0.12's built-in plugin manager.
-- Plugins stored in: stdpath('data')/site/pack/core/opt/
-- Lockfile: stdpath('config')/nvim-pack-lock.json  ← commit this

-- [[ Local plugins via rtp ]]
local custom = vim.fn.expand '~/dotfiles/nvim/lua/plugins/custom'
local function rtp_add(name)
    vim.opt.rtp:prepend(custom .. '/' .. name)
end

rtp_add 'kanso.nvim'
rtp_add 'oil.nvim'
rtp_add 'ncks.nvim'
rtp_add 'head.nvim'
rtp_add 'todo-comments.nvim'

-- [[ Build/post-install hooks ]]
-- Must be created before vim.pack.add() is called.
vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        if ev.data.kind == 'delete' then
            return
        end
        local name = ev.data.spec.name
        local function ensure_loaded()
            if not ev.data.active then
                vim.cmd.packadd(name)
            end
        end
        if name == 'nvim-treesitter' then
            ensure_loaded()
            vim.cmd 'TSUpdate'
        end
        if name == 'telescope-fzf-native.nvim' then
            ensure_loaded()
            local path = vim.fn.stdpath 'data' .. '/site/pack/core/opt/telescope-fzf-native.nvim'
            vim.fn.system { 'make', '-C', path }
        end
        if name == 'markdown-preview.nvim' then
            ensure_loaded()
            vim.fn['mkdp#util#install']()
        end
    end,
})

-- [[ Install & load all external plugins ]]
-- Dependencies must be listed before dependents.
vim.pack.add {
    -- Core dependencies (listed first)
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-lua/popup.nvim',
    'https://github.com/nvim-mini/mini.nvim',
    'https://github.com/nvim-mini/mini.indentscope',
    'https://github.com/nvim-mini/mini.base16',

    -- Snacks (early, many things depend on it)
    'https://github.com/folke/snacks.nvim',

    -- Completion & LSP deps (listed before dependents)
    'https://github.com/kevinhwang91/promise-async',
    'https://github.com/nvim-neotest/nvim-nio',
    'https://github.com/antoinemadec/FixCursorHold.nvim',
    'https://github.com/rouge8/neotest-rust',
    'https://github.com/L3MON4D3/LuaSnip',
    'https://github.com/saadparwaiz1/cmp_luasnip',
    'https://github.com/rafamadriz/friendly-snippets',
    'https://github.com/onsails/lspkind.nvim',
    'https://github.com/hrsh7th/cmp-nvim-lsp',
    'https://github.com/hrsh7th/cmp-buffer',
    'https://github.com/hrsh7th/cmp-path',
    'https://github.com/hrsh7th/cmp-cmdline',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
    'https://github.com/j-hui/fidget.nvim',
    'https://github.com/folke/lazydev.nvim',

    -- Treesitter deps
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
    'https://github.com/JoosepAlviste/nvim-ts-context-commentstring',

    'https://github.com/MeanderingProgrammer/render-markdown.nvim',

    -- Telescope deps
    'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
    'https://github.com/nvim-telescope/telescope-ui-select.nvim',
    'https://github.com/nvim-telescope/telescope-file-browser.nvim',

    -- Plugins
    'https://github.com/tpope/vim-sleuth',
    'https://github.com/windwp/nvim-autopairs',
    'https://github.com/folke/which-key.nvim',
    'https://github.com/MagicDuck/grug-far.nvim',
    'https://github.com/chrisgrieser/nvim-rip-substitute',
    'https://github.com/lewis6991/gitsigns.nvim',
    'https://github.com/petertriho/nvim-scrollbar',
    'https://github.com/numToStr/Comment.nvim',
    { src = 'https://github.com/jake-stewart/multicursor.nvim', version = '1.0' },
    { src = 'https://github.com/Vonr/align.nvim', version = 'v2' },
    'https://github.com/folke/trouble.nvim',
    'https://github.com/NickvanDyke/opencode.nvim',
    'https://github.com/kevinhwang91/nvim-ufo',
    'https://github.com/nvim-neotest/neotest',
    'https://github.com/stevearc/conform.nvim',
    'https://github.com/zbirenbaum/copilot.lua',
    'https://github.com/hrsh7th/nvim-cmp',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/rachartier/tiny-code-action.nvim',
    'https://github.com/cameron-wags/rainbow_csv.nvim',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-telescope/telescope.nvim',
    'https://github.com/rcarriga/nvim-notify',
    'https://github.com/MunifTanjim/nui.nvim',
    'https://github.com/folke/noice.nvim',
    'https://github.com/nvim-lualine/lualine.nvim',
    'https://github.com/akinsho/bufferline.nvim',
    'https://github.com/famiu/bufdelete.nvim',
    'https://github.com/jake-stewart/force-cul.nvim',
    'https://github.com/mcauley-penney/visual-whitespace.nvim',
    'https://github.com/uga-rosa/ccc.nvim',
    'https://github.com/akinsho/toggleterm.nvim',
    'https://github.com/mrjones2014/smart-splits.nvim',
    'https://github.com/kdheepak/lazygit.nvim',
    'https://github.com/tanvirtin/vgit.nvim',
    'https://github.com/sudormrfbin/cheatsheet.nvim',
    'https://github.com/folke/persistence.nvim',
    'https://github.com/chrishrb/gx.nvim',
    'https://github.com/antosha417/nvim-lsp-file-operations',
    'https://github.com/nvim-tree/nvim-tree.lua',
    'https://github.com/mikavilpas/yazi.nvim',
    'https://github.com/iamcco/markdown-preview.nvim',
    'https://github.com/stevearc/overseer.nvim',
    'https://github.com/tpope/vim-dadbod',
    'https://github.com/kristijanhusak/vim-dadbod-completion',
    'https://github.com/kristijanhusak/vim-dadbod-ui',
    'https://github.com/dundalek/bloat.nvim',
    'https://github.com/stevearc/quicker.nvim',
}

if vim.g.neovide then
    vim.pack.add { 'https://github.com/Rics-Dev/project-explorer.nvim' }
end

-- [[ Configure all plugins ]]
require 'plugins.colorscheme'
require 'plugins.snacks'
require 'plugins.coding'
require 'plugins.editor'
require 'plugins.lsp'
require 'plugins.telescope'
require 'plugins.ui'
require 'plugins.tree'
require 'plugins.custom'
require 'plugins.external'
require 'plugins.db'

-- [[ Fire VeryLazy event ]]
-- Equivalent to LazyVim's User VeryLazy - fires after all plugins are configured.
vim.schedule(function()
    vim.api.nvim_exec_autocmds('User', { pattern = 'VeryLazy', modeline = false }) ---@diagnostic disable-line: param-type-mismatch
end)

return {
    -- Just the bare minimum plugins for completion
    {
        'hrsh7th/nvim-cmp',
        lazy = false,
        priority = 1000,
        config = function()
            local cmp = require 'cmp'
            cmp.setup {
                mapping = cmp.mapping.preset.insert {
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm { select = true },
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                },
                sources = cmp.config.sources {
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                },
            }
        end,
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
        },
    },

    -- LSP setup completely separate from completion
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'mason-org/mason.nvim',
            'mason-org/mason-lspconfig.nvim',
        },
        config = function()
            require('mason').setup()
            require('mason-lspconfig').setup()

            -- Use basic capabilities
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            -- Setup servers
            local lspconfig = require 'lspconfig'
            lspconfig.lua_ls.setup {
                capabilities = capabilities,
            }

            -- Add other language servers as needed
        end,
    },
}

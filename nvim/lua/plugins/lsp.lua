return {
    { -- Go Language Support
        'ray-x/go.nvim',
        dependencies = { -- optional packages
            'ray-x/guihua.lua',
            'neovim/nvim-lspconfig',
            'nvim-treesitter/nvim-treesitter',
        },
        config = function()
            require('go').setup()
        end,
        event = { 'CmdlineEnter' },
        ft = { 'go', 'gomod' },
        build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    },

    { -- Autocompletion
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-buffer', -- source for text in buffer
            'L3MON4D3/LuaSnip', -- snippet engine
            'saadparwaiz1/cmp_luasnip', -- for autocompletion
            'rafamadriz/friendly-snippets', -- useful snippets
            'onsails/lspkind.nvim', -- vs-code like pictograms
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp', -- Explicitly require cmp-nvim-lsp
        },
        config = function()
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            local lspkind = require 'lspkind'
            require 'cmp_nvim_lsp' -- Explicitly require cmp-nvim-lsp

            -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
            require('luasnip.loaders.from_vscode').lazy_load()

            cmp.setup {
                completion = {
                    completeopt = 'menu,menuone,preview,noselect',
                },
                snippet = { -- configure how nvim-cmp interacts with snippet engine
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                    ['<Up>'] = cmp.mapping.select_prev_item(), -- previous suggestion
                    ['<Down>'] = cmp.mapping.select_next_item(), -- next suggestion
                    -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(), -- show completion suggestions
                    ['<C-e>'] = cmp.mapping.abort(), -- close completion window
                    ['<CR>'] = cmp.mapping.confirm { select = false },
                },
                -- sources for autocompletion
                sources = cmp.config.sources {
                    { name = 'cody' },
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- snippets
                    { name = 'buffer' }, -- text within current buffer
                    { name = 'path' }, -- file system paths
                },

                -- configure lspkind for vs-code like pictograms in completion menu
                formatting = {
                    format = lspkind.cmp_format {
                        maxwidth = 50,
                        ellipsis_char = '...',
                    },
                },
            }

            -- `sql` filetype setup. 'tpope/vim-dadbod'
            cmp.setup.filetype({ 'sql', 'mysql', 'plsql', 'sqlite' }, {
                sources = {
                    { name = 'vim-dadbod-completion' },
                    { name = 'buffer' },
                },
            })

            -- `:` cmdline setup.
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' },
                }, {
                    {
                        name = 'cmdline',
                        option = {
                            ignore_cmds = { 'Man', '!' },
                        },
                    },
                }),
            })
        end,
    },

    {
        'rachartier/tiny-code-action.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope.nvim' },
        },
        event = 'LspAttach',
        config = function()
            require('tiny-code-action').setup {
                telescope_opts = {
                    layout_strategy = 'vertical',
                    layout_config = {
                        width = 0.7,
                        height = 0.6,
                        preview_cutoff = 1,
                        preview_height = function(_, _, max_lines)
                            local h = math.floor(max_lines * 0.5)
                            return math.max(h, 10)
                        end,
                    },
                },
            }
        end,
    },

    { -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            { 'j-hui/fidget.nvim', opts = {} },

            {
                'folke/neodev.nvim',
                config = function()
                    require('neodev').setup {
                        library = { plugins = { 'nvim-dap-ui' }, types = true },
                    }
                end,
            },
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    local builtin = require 'telescope.builtin'

                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                    map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
                    map('gr', builtin.lsp_references, '[G]oto [R]eferences')
                    map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
                    map('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
                    map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
                    map('<F2>', vim.lsp.buf.rename, '[R]e[n]ame')
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
                    map('K', vim.lsp.buf.hover, 'Hover Documentation')
                    map('gr', vim.lsp.buf.references, 'Show [R]eferences')

                    -- workspace management. Necessary for multi-module projects
                    map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[A]dd [W]orkspace Folder')
                    map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[R]emove [W]orkspace Folder')
                    map('<leader>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, '[L]ist [W]orkspace Folders')
                    map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            local servers = {
                rust_analyzer = {
                    settings = {
                        ['rust-analyzer'] = {
                            checkOnSave = {
                                command = 'clippy',
                            },
                            cargo = {
                                allFeatures = true,
                            },
                            procMacro = {
                                enable = true,
                            },
                            rustfmt = {
                                extraArgs = { '--config', 'max_width=200' },
                            },
                        },
                    },
                },
                gopls = {
                    settings = {
                        gopls = {
                            staticcheck = true,
                            gofumpt = true,
                            buildFlags = { '-tags=integration' },
                            -- Disable the 'gc' check which includes the "main redeclared" error
                            analyses = {
                                unusedparams = true,
                                shadow = false,
                                gc = false,
                            },
                        },
                    },
                    handlers = {
                        ['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
                            local diagnostics = result.diagnostics
                            local filtered_diagnostics = vim.tbl_filter(function(diagnostic)
                                return not diagnostic.message:match 'main redeclared in this block'
                            end, diagnostics)
                            result.diagnostics = filtered_diagnostics
                            vim.lsp.handlers['textDocument/publishDiagnostics'](_, result, ctx, config)
                        end,
                    },
                },
                tsserver = {},
                tailwindcss = {
                    -- Tailwindcss support for Rust (leptos/yew/dioxus/etc)
                    filetypes = {
                        'css',
                        'scss',
                        'sass',
                        'postcss',
                        'html',
                        'javascript',
                        'javascriptreact',
                        'typescript',
                        'typescriptreact',
                        'svelte',
                        'vue',
                        'rust',
                    },
                    init_options = {
                        -- There you can set languages to be considered as different ones by tailwind lsp I guess same as includeLanguages in VSCod
                        userLanguages = {
                            rust = 'html',
                        },
                    },
                    experimental = {
                        classRegex = {
                            [[class="([^"]*)]],
                            'class=\\s+"([^"]*)',
                        },
                    },
                    -- Here If any of files from list will exist tailwind lsp will activate.
                    root_dir = require('lspconfig').util.root_pattern(
                        'tailwind.config.js',
                        'tailwind.config.ts',
                        'postcss.config.js',
                        'postcss.config.ts',
                        'windi.config.ts'
                    ),
                },
                -- NOTE: This alone doesn't work. Starting `sourcekit-lsp` manually in autocmds.lua works, apparently.
                -- sourcekit = {
                --     filetypes = { 'swift', 'c', 'cpp', 'objective-c', 'objective-cpp' },
                --     root_dir = require('lspconfig').util.root_pattern(
                --         'buildServer.json',
                --         '*.xcodeproj',
                --         '*.xcworkspace',
                --         '.git',
                --         'compile_commands.json',
                --         'Package.swift'
                --     ),
                --     cmd = {
                --         -- '~/Applications/Xcode-15.0.0.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp',
                --         '/usr/bin/sourcekit-lsp',
                --     },
                --     capabilities = {
                --         require('cmp_nvim_lsp').default_capabilities(),
                --     },
                -- },
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = {
                                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                                version = 'LuaJIT',
                            },
                            diagnostics = {
                                -- Get the language server to recognize the `vim` global
                                globals = { 'vim' },
                                -- Keep your existing setting to disable 'missing-fields' warnings
                                disable = { 'missing-fields' },
                            },
                            workspace = {
                                -- Make the server aware of Neovim runtime files
                                library = vim.api.nvim_get_runtime_file('', true),
                                checkThirdParty = false,
                            },
                            -- Do not send telemetry data containing a randomized but unique identifier
                            telemetry = {
                                enable = false,
                            },
                            completion = {
                                callSnippet = 'Replace',
                            },
                        },
                    },
                },
            }

            -- :Mason
            --  You can press `g?` for help in this menu.
            require('mason').setup()

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                'stylua', -- Used to format Lua code
                'gopls',
            })
            require('mason-tool-installer').setup { ensure_installed = ensure_installed }

            require('mason-lspconfig').setup {
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            }
        end,
    },

    { -- CSV Highlighting
        'cameron-wags/rainbow_csv.nvim',
        config = true,
        ft = {
            'csv',
            'tsv',
            'csv_semicolon',
            'csv_whitespace',
            'csv_pipe',
            'rfc_csv',
            'rfc_semicolon',
        },
        cmd = {
            'RainbowAlign',
            'RainbowDelim',
            'RainbowDelimSimple',
            'RainbowDelimQuoted',
            'RainbowMultiDelim',
        },
    },

    {
        'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim',
        config = function()
            require('toggle_lsp_diagnostics').init()
        end,
    },
}

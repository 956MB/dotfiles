-- [[ nvim-cmp: completion ]]
local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'

require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup {
    performance = {
        debounce = 0,
        throttle = 0,
    },
    completion = {
        completeopt = 'menu,menuone,preview,noselect',
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<Up>'] = cmp.mapping.select_prev_item(),
        ['<Down>'] = cmp.mapping.select_next_item(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm { select = false },
    },
    sources = cmp.config.sources {
        { name = 'lazydev', group_index = 0 },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    },
    formatting = {
        format = lspkind.cmp_format {
            maxwidth = 50,
            ellipsis_char = '...',
        },
    },
}

cmp.setup.filetype({ 'sql', 'mysql', 'plsql', 'sqlite' }, {
    sources = {
        { name = 'vim-dadbod-completion' },
        { name = 'buffer' },
    },
})

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

-- [[ lazydev.nvim: Neovim API completion ]]
require('lazydev').setup {
    library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
}

-- [[ fidget.nvim: LSP progress ]]
require('fidget').setup {}

-- [[ tiny-code-action ]]
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

-- [[ mason ]]
require('mason').setup()

-- stylua is a formatter only; prevent it from ever activating as an LSP server
vim.lsp.config('stylua', { filetypes = {} })

-- [[ nvim-lspconfig ]]
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
        map('<F2>', vim.lsp.buf.rename, '[R]ename')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
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
local has_cmp_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp_lsp then
    capabilities = vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())
else
    capabilities.textDocument.completion.completionItem.snippetSupport = true
end

local function get_clangd_cmd()
    local cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--completion-style=detailed',
        '--function-arg-placeholders=0',
    }

    local util = require 'lspconfig.util'
    local root_dir = util.find_git_ancestor(vim.fn.getcwd())
    if root_dir then
        local arm_toolchain = root_dir .. '/toolchain/arm64-darwin/bin/arm-none-eabi-gcc'
        if vim.fn.filereadable(arm_toolchain) == 1 then
            table.insert(cmd, '--query-driver=' .. arm_toolchain)
        end
        local compile_cmds = root_dir .. '/build/latest/compile_commands.json'
        if vim.fn.filereadable(compile_cmds) == 1 then
            table.insert(cmd, '--compile-commands-dir=' .. root_dir .. '/build/latest')
        end
    end

    return cmd
end

local servers = {
    clangd = {
        cmd = get_clangd_cmd(),
        capabilities = { offsetEncoding = 'utf-16' },
    },
    rust_analyzer = {
        settings = {
            ['rust-analyzer'] = {
                checkOnSave = { command = 'clippy' },
                cargo = { allFeatures = true },
                procMacro = { enable = true },
                rustfmt = { extraArgs = { '--config', 'max_width=200' } },
            },
        },
    },
    gopls = {
        settings = {
            gopls = {
                staticcheck = true,
                gofumpt = true,
                buildFlags = { '-tags=integration' },
                analyses = {
                    unusedparams = true,
                    shadow = false,
                    gc = false,
                },
            },
        },
        handlers = {
            ['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
                local filtered = vim.tbl_filter(function(d)
                    return not d.message:match 'main redeclared in this block'
                end, result.diagnostics)
                result.diagnostics = filtered
                vim.lsp.handlers['textDocument/publishDiagnostics'](_, result, ctx, config)
            end,
        },
    },
    ts_ls = {},
    tailwindcss = {
        filetypes = {
            'css', 'scss', 'sass', 'postcss', 'html',
            'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
            'svelte', 'vue', 'rust',
        },
        init_options = {
            userLanguages = { rust = 'html' },
        },
        experimental = {
            classRegex = {
                [[class="([^"]*)]],
                'class=\\s+"([^"]*)',
            },
        },
        root_dir = require('lspconfig').util.root_pattern(
            'tailwind.config.js',
            'tailwind.config.ts',
            'postcss.config.js',
            'postcss.config.ts',
            'windi.config.ts'
        ),
    },
    lua_ls = {
        settings = {
            Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = {
                    globals = { 'vim' },
                    disable = { 'missing-fields' },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file('', true),
                    checkThirdParty = false,
                },
                telemetry = { enable = false },
                completion = { callSnippet = 'Replace' },
            },
        },
    },
    zls = {
        cmd = { 'zls' },
        filetypes = { 'zig' },
        root_dir = require('lspconfig').util.root_pattern('build.zig', 'build.zig.lock', 'compile_commands.json', '.git'),
        settings = {
            zls = {
                enableSnippets = true,
                enableDiagnostics = true,
                enableCodeActions = true,
            },
        },
    },
    pylsp = {
        settings = {
            pylsp = {
                plugins = {
                    pycodestyle = {
                        ignore = { 'E302', 'E501', 'E305', 'E401', 'E226' },
                        maxLineLength = 400,
                    },
                    flake8 = { enabled = false },
                },
            },
        },
    },
}

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
    'stylua',
    'gopls',
    'clangd',
    'typescript-language-server',
})
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

require('mason-lspconfig').setup {
    handlers = {
        -- stylua is a formatter only; prevent mason-lspconfig from starting it as an LSP server
        stylua = function() end,
        function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
        end,
    },
}

-- [[ rainbow_csv ]]
-- No setup needed; activates on csv/tsv filetypes automatically.

-- [[ project-explorer (Neovide only) ]]
if vim.g.neovide then
    require('project_explorer').setup {
        paths = { '~/Dev/*' },
        newProjectPath = '~/Dev/',
        file_explorer = function(dir)
            require('oil').open(dir)
        end,
    }
    vim.keymap.set('n', '<leader>fp', '<cmd>ProjectExplorer<cr>', { desc = 'Project Explorer' })
end

local swift_lsp = vim.api.nvim_create_augroup('swift_lsp', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'swift' },
    callback = function()
        local function find_swift_root()
            local path = vim.fn.expand '%:p:h'
            while path ~= '/' do
                for _, name in ipairs { 'buildServer.json', 'Package.swift' } do
                    if vim.fn.filereadable(path .. '/' .. name) == 1 then
                        return path
                    end
                end
                local entries = vim.fn.glob(path .. '/*.xcodeproj', false, true)
                vim.list_extend(entries, vim.fn.glob(path .. '/*.xcworkspace', false, true))
                if #entries > 0 then
                    return path
                end
                if vim.fn.isdirectory(path .. '/.git') == 1 or vim.fn.filereadable(path .. '/.git') == 1 then
                    return path
                end
                path = vim.fn.fnamemodify(path, ':h')
            end
            return vim.fn.expand '%:p:h'
        end

        local root_dir = find_swift_root()
        local xcode_sourcekit = vim.fn.trim(vim.fn.system { 'xcrun', '--find', 'sourcekit-lsp' })
        local sourcekit_bin = (xcode_sourcekit ~= '' and vim.fn.executable(xcode_sourcekit) == 1)
                and xcode_sourcekit
            or 'sourcekit-lsp'

        local cmd = { sourcekit_bin }
        if vim.fn.filereadable(root_dir .. '/buildServer.json') == 1 then
            vim.list_extend(cmd, { '--default-workspace-type', 'buildServer' })
        end

        local client_id = vim.lsp.start {
            name = 'sourcekit-lsp',
            cmd = cmd,
            root_dir = root_dir,
        }
        if client_id then
            vim.lsp.buf_attach_client(0, client_id)
        end
    end,
    group = swift_lsp,
})

-- Disable diagnostics for generated interface files from sourcekit-lsp
vim.api.nvim_create_autocmd('BufEnter', {
    group = swift_lsp,
    pattern = '*/sourcekit-lsp/GeneratedInterfaces/*',
    callback = function(args)
        vim.diagnostic.enable(false, { bufnr = args.buf })
    end,
})

-- Set the filetype of .db files to sqlite (prisma)
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = '*.db',
    callback = function()
        vim.bo.filetype = 'sqlite'
    end,
})

-- Reload Neovim config when changes are made to the lua directory
local config_path = vim.env.LAZYVIM_CONFIG_PATH or vim.fn.stdpath 'config'

vim.api.nvim_create_augroup('ReloadConfig', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
    group = 'ReloadConfig',
    pattern = config_path .. '/**/*', -- Watch for changes in any file under the config directory
    command = 'source ' .. config_path .. '/init.lua', -- Reload the init.lua file
})

-- golings file save/watch nonsense work around
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.go',
    callback = function()
        local file = vim.fn.expand '<afile>:p'
        local is_exercise = string.match(file, 'exercises/.+/main%.go$')
        local golings_in_path = vim.fn.executable 'golings' == 1

        if golings_in_path or is_exercise then
            -- Disable the 'writebackup' option temporarily
            local old_writebackup = vim.o.writebackup
            vim.o.writebackup = false

            vim.cmd 'write!'
            vim.o.writebackup = old_writebackup
            vim.cmd 'edit!'
        end
    end,
})

-- Function to load local config
local function load_local_config()
    local local_config = vim.fn.getcwd() .. '/.nvim.lua'
    if vim.fn.filereadable(local_config) == 1 then
        dofile(local_config)
    end
end

-- Create an autocommand to load the local config after changing directories
vim.api.nvim_create_autocmd({ 'DirChanged' }, {
    pattern = '*',
    callback = load_local_config,
})

-- Load local config on startup
load_local_config()

-- Deferred autocmds
vim.defer_fn(function()
    -- Highlight when yanking (copying) text
    --  Try it with `yap` in normal mode
    --  See `:help vim.highlight.on_yank()`
    vim.api.nvim_create_autocmd('TextYankPost', {
        desc = 'Highlight when yanking (copying) text',
        group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
        callback = function()
            vim.highlight.on_yank()
        end,
    })

    -- Turn off spell when opening markdown files
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
            vim.wo.spell = false
        end,
    })

    -- Merged BufEnter autocommands for disabling relative numbers and enabling wrap
    local buffer_settings = vim.api.nvim_create_augroup('BufferSettings', { clear = true })
    vim.api.nvim_create_autocmd('BufEnter', {
        group = buffer_settings,
        callback = function()
            vim.wo.relativenumber = false -- Disable relative line numbers
            vim.wo.wrap = true -- Enable text wrapping
        end,
    })

    -- Apply padding when entering a window
    -- vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter' }, {
    --     callback = SetWindowPadding,
    -- })
end, 0) -- 0 ms delay, but still deferred

-- Window padding
function SetWindowPadding()
    local api = vim.api
    local win = api.nvim_get_current_win()
    local buf = api.nvim_win_get_buf(win)
    local buftype = api.nvim_get_option_value('buftype', { buf = buf })
    local filetype = api.nvim_get_option_value('filetype', { buf = buf })

    -- toggleterm.nvim
    local is_toggleterm = pcall(function()
        return api.nvim_buf_get_var(buf, 'toggle_number') ~= nil
    end) or filetype == 'toggleterm'
    -- diffview.nvim
    local is_diffview = string.match(api.nvim_buf_get_name(buf), '^diffview:///')

    -- Only apply padding to normal buffers, nvim-tree and diffview
    if (buftype == '' or filetype == 'NvimTree' or is_diffview) and not is_toggleterm then
        local width = api.nvim_win_get_width(win)
        if width > 1 then
            api.nvim_set_option_value('winbar', string.rep(' ', width), { win = win })
        end
    else
        api.nvim_set_option_value('winbar', nil, { win = win })
    end
end

-- Disable automatic comment insertion on new lines
vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function()
        vim.opt_local.formatoptions:remove { 'r', 'o' }
    end,
})

-- [[ System appearance (light/dark) → colorscheme ]]
-- Ghostty follows the OS appearance natively (`theme = light:…,dark:…` in ghostty/config)
-- and Zed via `theme.mode = "system"`. Neovim has no such hook, so this module watches for
-- the OS appearance and keeps one colorscheme pair in sync:
--
--     dark  → kanso       (kanso.nvim ink — the long-standing repo default)
--     light → koda-glade  (koda.nvim glade, its light variant: koda pairs moss/glade)
--
-- Themery (plugins/colorscheme.lua) still owns manual picks: the pair is only re-applied
-- while one of the two is the active colorscheme, so a persisted pick such as matteblack
-- or greyscale is never stomped. A pinned pick also keeps `background` as it stands, so
-- pinning the light koda variants (koda-light, koda-pearl) leaves `background = "dark"`
-- from config/options.lua — lualine & co. then use their dark fallback theme.
-- `:SystemTheme` re-checks on demand and the timer covers the normal case of flipping the
-- OS appearance while Neovim runs.

local M = {}

local AUTO = { dark = 'kanso', light = 'koda-glade' }
local POLL_INTERVAL_MS = 5000

local uv = vim.uv or vim.loop
local timer ---@type uv_timer_t|nil
local busy = false

local function is_auto(name)
    return name == AUTO.dark or name == AUTO.light
end

--- Command that reports the OS appearance plus a parser for its output.
--- macOS: `defaults` prints "Dark" and exits 0 in dark mode, exits non-zero in light mode.
--- GNOME: prefer-dark | prefer-light | default (no preference → nil, keep what is active).
---@return string[]|nil argv, fun(out: string): 'dark'|'light'|nil|nil
local function query()
    if uv.os_uname().sysname == 'Darwin' then
        return { 'defaults', 'read', '-g', 'AppleInterfaceStyle' }, function(out)
            return out:lower():match 'dark' and 'dark' or 'light'
        end
    end
    if vim.fn.executable 'gsettings' == 1 then
        return { 'gsettings', 'get', 'org.gnome.desktop.interface', 'color-scheme' }, function(out)
            out = out:lower()
            if out:match 'prefer%-dark' then
                return 'dark'
            end
            if out:match 'prefer%-light' then
                return 'light'
            end
            return nil
        end
    end
    return nil
end

--- Detect the OS appearance, synchronously (startup path, ~6ms).
---@return 'dark'|'light'|nil nil when the platform has no way to tell
function M.detect()
    local argv, parse = query()
    if not argv then
        return nil
    end
    return parse(vim.fn.system(argv))
end

--- Apply the colorscheme matching the current appearance.
--- No-op when `mode` is nil or a manually picked colorscheme is active.
---@param mode 'dark'|'light'|nil override; detected when nil
---@return boolean applied
function M.apply(mode)
    mode = mode or M.detect()
    if not mode then
        return false
    end

    local current = vim.g.colors_name
    if current and not is_auto(current) then
        -- A manual pick (themery, :colorscheme) owns the theme, and with it `background`.
        return false
    end

    if vim.o.background ~= mode then
        vim.o.background = mode -- plugins reading `background` (lualine auto, …) follow
    end

    local target = AUTO[mode]
    if current == target then
        return false
    end

    local ok = pcall(vim.cmd.colorscheme, target)
    if not ok then
        vim.notify(('appearance: colorscheme %q is missing'):format(target), vim.log.levels.WARN)
    end
    return ok
end

--- Re-check the appearance without blocking, then apply.
local function poll()
    local argv, parse = query()
    if not argv or busy then
        return
    end
    -- Themery's picker live-previews themes; leave it alone while it is open.
    if vim.bo.filetype == 'themery' then
        return
    end
    busy = true
    vim.system(argv, { text = true }, function(result)
        busy = false
        local mode = parse(result.stdout or '')
        if mode then
            vim.schedule(function()
                M.apply(mode)
            end)
        end
    end)
end

--- Start watching the OS appearance (idempotent).
function M.watch()
    if timer or not query() then
        return
    end
    timer = uv.new_timer()
    timer:start(POLL_INTERVAL_MS, POLL_INTERVAL_MS, vim.schedule_wrap(poll))

    -- Flipping the appearance usually happens in another window, so re-check on return.
    vim.api.nvim_create_autocmd('FocusGained', {
        group = vim.api.nvim_create_augroup('appearance', { clear = true }),
        desc = 'Re-check the OS appearance',
        callback = poll,
    })
end

--- `:SystemTheme` — re-check now (and report when nothing can be detected).
vim.api.nvim_create_user_command('SystemTheme', function()
    local mode = M.detect()
    if not mode then
        vim.notify('appearance: cannot detect the OS appearance on this system', vim.log.levels.WARN)
        return
    end
    if not M.apply(mode) then
        vim.notify('appearance: ' .. (vim.g.colors_name or 'unknown') .. ' is pinned, not switching')
    end
end, { desc = 'Apply the colorscheme for the current OS appearance' })

return M

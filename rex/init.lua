-- Rex configuration. Source of truth: ~/dotfiles/rex/init.lua
-- Linked to ~/.config/rex (see `dot symlinks`).
-- Apply changes with: rex config reload     Validate with: rex config check

-- Tabs — mirrors herdr: previous_tab = ctrl+left, next_tab = ctrl+right
-- Tabs and sessions both live in Rex's left sidebar; these keep the
-- horizontal switch for tabs and the vertical switch for sessions.
rex.bind("ctrl+left", "client.tab.previous")
rex.bind("ctrl+right", "client.tab.next")

-- Sessions — mirrors herdr: previous_workspace = ctrl+shift+up,
-- next_workspace = ctrl+shift+down
rex.bind("ctrl+shift+up", "session.previous")
rex.bind("ctrl+shift+down", "session.next")

-- Sidebar — ctrl+b (herdr: toggle_sidebar = prefix+b)
-- The Rex app ships cmd+/ for this; config bindings stack over app defaults, so
-- both work. Drop the app default in Rex's shortcut settings if you want ctrl+b
-- only.
rex.bind("ctrl+b", "client.sidebar.toggle")

-- New session — ctrl+shift+n (herdr: new_workspace = prefix+shift+n)
rex.bind("ctrl+shift+n", "session.new")

-- New / close tab — ctrl+t / ctrl+w (ghostty: super+t / super+w are terminal tabs)
rex.bind("ctrl+t", "client.tab.new")
rex.bind("ctrl+w", "client.tab.close")

-- Mac-side interactive coordinator; remote work travels through Rex/Tailscale.
-- Custom action names use underscores (Rex does not allow hyphens).
rex.action{
    name = "rex_sync_dotfiles",
    title = "Sync Dotfiles to Fedora",
    description = "Send the sync skill to the focused dotfiles Pi, or open Pi if none is running.",
    args = { model = "string?" },
    run = function(ctx, args)
        local platform, platform_err = rex.exec({ "uname", "-s" })
        if platform_err or not platform.ok or platform.stdout:match("^Darwin") == nil then
            error("Run this action on the Mac Studio Rex server", 0)
        end

        local view, view_err = rex.session.view{ session_id = ctx.session_id }
        if view_err then error(view_err, 0) end
        local terminal = "com.superlogical.terminal"
        local candidates = {}
        for _, window in ipairs(view.windows or {}) do
            for _, layer in ipairs(window.layers or {}) do
                for _, block in ipairs(layer.blocks or {}) do
                    if block.creator_name == terminal then
                        local process = rex.block.call(terminal, "process", {
                            session_id = ctx.session_id,
                            block_id = block.block_id,
                        })
                        local foreground = process and process.foreground
                        if foreground and foreground.argv0 == "pi" and foreground.cwd == os.getenv("HOME") .. "/dotfiles" then
                            table.insert(candidates, { block_id = block.block_id, window_id = window.window_id })
                        end
                    end
                end
            end
        end

        local selected
        for _, candidate in ipairs(candidates) do
            if candidate.block_id == ctx.block_id then selected = candidate; break end
        end
        if not selected then
            for _, candidate in ipairs(candidates) do
                if candidate.window_id == view.active_window_id then selected = candidate; break end
            end
        end
        if not selected and #candidates == 1 then selected = candidates[1] end
        if not selected and #candidates > 1 then
            error("Multiple dotfiles Pi panes; focus the desired pane before running the action", 0)
        end
        if selected then
            local result, err = rex.block.call(terminal, "write", {
                session_id = ctx.session_id,
                block_id = selected.block_id,
                data = "/skill:rex-sync-dotfiles\r",
            })
            if err then error(err, 0) end
            return { block_id = selected.block_id, window_id = selected.window_id }
        end

        local command = 'exec bash "$HOME/dotfiles/scripts/rex-sync-dotfiles"'
        if args.model and args.model ~= "" then
            -- Pass the model as a positional argument rather than interpolating shell text.
            command = command .. ' --model "$1"'
        end
        local window, err = rex.session.new_window{
            session_id = ctx.session_id,
            window_label = "Dotfiles Sync",
            layout = rex.layout.block{
                flavor = "com.superlogical.terminal.shell",
                options = {
                    command = { "bash", "-lc", command, "rex-sync-dotfiles", args.model or "" },
                },
            },
        }
        if err ~= nil then error(err, 0) end
        return { window_id = window.window_id }
    end,
}

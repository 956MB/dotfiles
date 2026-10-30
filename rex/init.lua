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

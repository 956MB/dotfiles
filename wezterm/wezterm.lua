local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

config.colors = {
	foreground = "#c7c7c7",
	background = "#0D0D0D",
	selection_fg = "#000000",
	selection_bg = "#BFBFBF",

	ansi = {
		"#686868", -- black
		"#FA2C3A", -- red
		"#5B9B4C", -- green
		"#DCDCAA", -- yellow
		"#3794FF", -- blue
		"#C586C0", -- magenta
		"#4EC9B0", -- cyan
		"#c7c7c7", -- white
	},
	brights = {
		"#686868", -- bright black
		"#FA2C3A", -- bright red
		"#5B9B4C", -- bright green
		"#DCDCAA", -- bright yellow
		"#3794FF", -- bright blue
		"#C586C0", -- bright magenta
		"#4EC9B0", -- bright cyan
		"#c7c7c7", -- bright white
	},

	tab_bar = {
		background = "#0D0D0D",
		active_tab = {
			bg_color = "#0000ff",
			fg_color = "#ddd",
		},
		inactive_tab = {
			bg_color = "#00ff00",
			fg_color = "#B5B5B5",
		},
	},
}

-- Font
config.font_size = 9
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.line_height = 1.1
config.default_cursor_style = "SteadyBar"

-- Window
config.allow_square_glyphs_to_overflow_width = "Never"
config.audible_bell = "Disabled"
config.window_decorations = "TITLE | RESIZE"
config.window_padding = {
	left = 8,
	right = 8,
	top = 4,
	bottom = 5,
}
config.window_background_opacity = 1.0

-- Tab
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.tab_max_width = 25
config.hide_tab_bar_if_only_one_tab = false

-- WSL
config.default_domain = "WSL:Ubuntu-22.04"
config.default_prog = { "wsl.exe", "~" }

-- Keys
config.keys = {
	-- Tab navigation
	{
		key = "RightArrow",
		mods = "ALT", -- Changed from CMD to ALT for Windows
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		key = "LeftArrow",
		mods = "ALT", -- Changed from CMD to ALT for Windows
		action = wezterm.action.ActivateTabRelative(-1),
	},
	-- Move tabs
	{
		key = "RightArrow",
		mods = "SHIFT|ALT", -- Changed from CMD to ALT for Windows
		action = wezterm.action.MoveTabRelative(1),
	},
	{
		key = "LeftArrow",
		mods = "SHIFT|ALT", -- Changed from CMD to ALT for Windows
		action = wezterm.action.MoveTabRelative(-1),
	},
	-- Split panes
	{
		key = "-",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitVertical,
	},
	{
		key = "\\",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitHorizontal,
	},
	-- Resize panes
	{
		key = "UpArrow",
		mods = "CTRL",
		action = wezterm.action.AdjustPaneSize({ "Up", 1 }),
	},
	{
		key = "DownArrow",
		mods = "CTRL",
		action = wezterm.action.AdjustPaneSize({ "Down", 1 }),
	},
	-- Select tab (similar to kitty's select_tab)
	{
		key = "t",
		mods = "ALT", -- Changed from CMD to ALT for Windows
		action = wezterm.action.ShowTabNavigator,
	},
	-- paste from the clipboard
	{ key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
}

-- Custom tab format (simplified version of kitty's complex template)
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local cwd = tab.active_pane.current_working_dir or ""
	local cwd_name = cwd:match("([^/]+)/?$") or ""

	if tab.is_active then
		return string.format(" %d: %s ", tab.tab_index + 1, cwd_name)
	else
		return string.format(" %s ", cwd_name)
	end
end)

return config

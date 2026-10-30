# Appearance-dependent environment for the CLI tools that cannot detect light/dark themselves.
# appearance_sync (fish/functions/appearance_sync.fish) sets BAT_THEME, DELTA_FEATURES and
# LG_CONFIG_FILE from the OS appearance; it also re-registers itself on the fish_prompt event,
# so a flip in macOS appearance reaches the next bat/delta/lazygit launch.
#
# Tools covered: bat (BAT_THEME overrides the --theme in bat/config), delta (BAT_THEME for the
# syntax theme, DELTA_FEATURES for the diff washes), lazygit (LG_CONFIG_FILE adds the light
# gui.theme override). See themes/GREYSCALE.md → "Light/dark wiring".
appearance_sync

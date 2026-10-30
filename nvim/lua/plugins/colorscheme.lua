-- [[ Colorscheme selection ]]
-- The default follows the OS appearance (config/appearance.lua): kanso for dark,
-- koda-glade for light (koda's own light variant). Ghostty does the same natively via
-- `theme = light:…,dark:…`, so the terminal and the editor flip together.
--
-- Kanso comes from the kanso.nvim submodule at nvim/lua/plugins/custom/kanso.nvim,
-- added to the rtp in config/pack.lua. The fork default is the ink variant
-- (#1C1C1C editor bg, zen #111111 panels). Koda (greyscale/koda-dark, koda-light,
-- koda-glade) is the second submodule, custom/koda.nvim.
--
-- Themery (below) owns switching: `:Themery` lists the themes and remembers the pick.
-- A persisted pick other than kanso / koda-glade pins the theme across restarts; picking
-- kanso or koda glade hands the theme back to the appearance watcher (in light mode kanso
-- is switched to koda-glade again, and vice versa).
--
-- To pin a theme regardless of appearance, drop it from the themery list or set it here:
-- vim.cmd 'colorscheme koda-dark'
-- vim.cmd 'colorscheme matteblack'

local appearance = require 'config.appearance'

-- [[ koda — light halves on pure white ]]
-- Light-mode backgrounds are #ffffff across this repo (ghostty, pi, herdr), so the koda
-- light palettes get a white `bg` on top of their upstream values (`light` = warm
-- off-white #faf9f5 upstream, `glade` = #f7f7f7) instead of patching the submodule.
-- koda's highlight cache is keyed by theme and invalidated when `colors` changes, so the
-- override always takes effect. Must run before themery: a persisted koda-glade/koda-light
-- pick is applied by themery.setup below, and apply() would not re-apply an identical theme.
require('koda').setup {
    colors = {
        light = { bg = '#ffffff' },
        glade = { bg = '#ffffff' },
    },
}

-- [[ themery.nvim — theme picker ]]
-- Runs first so a persisted choice is known before the appearance default is picked:
-- a pick other than the appearance pair (kanso / koda-light) pins the theme and is left
-- alone. Selecting a theme with <cr> writes it to themery's state file and re-applies it
-- on startup.
require('themery').setup {
    themes = {
        { name = 'kanso', colorscheme = 'kanso' },
        { name = 'kanso zen', colorscheme = 'kanso-zen' },
        { name = 'kanso pearl', colorscheme = 'kanso-pearl' },
        { name = 'greyscale', colorscheme = 'koda-dark' },
        { name = 'koda light', colorscheme = 'koda-light' },
        { name = 'koda glade', colorscheme = 'koda-glade' },
        { name = 'matteblack', colorscheme = 'matteblack' },
    },
    livePreview = true,
}

-- [[ default for the current OS appearance — kanso (dark) / koda-glade (light) ]]
appearance.apply()

-- [[ keep the appearance pair in sync at runtime ]]
appearance.watch()
vim.schedule(appearance.apply)

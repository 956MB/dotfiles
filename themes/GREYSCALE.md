# GREYSCALE.md — Greyscale Theme Style Guide

> Based on the BAShtop "grayscale" theme by aristocratos (btop's built-in default). The greyscale
> conglomerate combines the original btop neutral ramp with koda-dark semantic colors and the
> deep matte-black diff washes selected for this repo. Live in btop: `color_theme = "/opt/homebrew/Cellar/btop/1.4.7/share/btop/themes/greyscale.theme"`.
> This file documents the source ramp, the complete koda-dark color set used by the ports, and
> the implemented tool wiring.

## The ramp (canonical palette)

btop uses 2-character hex abbreviations: `"#RR"` repeats the channel → `#RRRRRR`. The whole theme
is one 7-step luminance ramp (dark → light):

| Abbrev | Hex | btop role |
|---|---|---|
| `#00` | `#000000` | `main_bg` (terminal default in btop itself), `selected_fg` (inverted selection) |
| `#30` | `#303030` | `inactive_fg`, `div_line`, `download`/`upload` meter start |
| `#50` | `#505050` | graph/meter **start** (temp, cpu, free, cached, available, used) |
| `#90` | `#909090` | `hi_fg` (shortcut highlight), `proc_misc`, box outlines (`cpu_box`, `mem_box`, `net_box`, `proc_box`) |
| `#bb` | `#BBBBBB` | `main_fg` (primary text) |
| `#cc` | `#CCCCCC` | `title` (box titles) |
| `#ff` | `#FFFFFF` | `selected_bg` (inverted selection), graph/meter **end** |

**Extrapolated steps** (not in the btop file, added for editor ports — documented, do not forget):

| Hex | Use | Why |
|---|---|---|
| `#202020` | line/cursorline highlight | between `#000` and `#30`; subtle row hover |
| `#737373` | comments (`"#73"` fits the 2-char idiom) | only ramp value ≥ 4.5:1 on black below `#90` |

## btop role map (verbatim from greyscale.theme)

| Key | Value | Meaning |
|---|---|---|
| `main_bg` | `#00` | background, empty = transparent (btop only) |
| `main_fg` | `#bb` | main text |
| `title` | `#cc` | box titles |
| `hi_fg` | `#90` | keyboard-shortcut highlight |
| `selected_bg` / `selected_fg` | `#ff` / `#00` | selected item = **inverted** (white/black) |
| `inactive_fg` | `#30` | inactive/disabled text |
| `proc_misc` | `#90` | processes-box misc (mini cpu graphs, details) |
| `cpu_box` / `mem_box` / `net_box` / `proc_box` | `#90` | box outlines |
| `div_line` | `#30` | box dividers / small-box lines |
| `temp_start`·`cpu_start`·`free_start`·`cached_start`·`available_start`·`used_start` | `#50` | meter gradient start |
| `download_start` / `upload_start` | `#30` | net meters start dimmer |
| all `*_mid` | (empty) | no 3-color gradients — all meters ramp start → `#ff` |
| all `*_end` | `#ff` | meter gradient end (white) |

Design reads: background black, text #bb, titles one step brighter (#cc), accents at #90,
dim/inactive at #30, and the only "loud" color is white — used for selection (inverted) and
meter peaks.

## Btop-only semantic mapping (reference)

This pure-ramp mapping is retained for tools that should stay fully neutral. It is the original
mapping used by the reference `lazygit/Greyscale.tmTheme`; the active ports below use the koda-dark
mapping when semantic color improves readability:

| Role | Color | Style | Notes |
|---|---|---|---|
| background | `#000000` | — | main_bg |
| foreground | `#BBBBBB` | — | main_fg |
| comment | `#737373` | italic | extrapolated step; AA on black |
| string | `#CCCCCC` | — | title-level brightness |
| number / constant | `#BBBBBB` | — | main level; `constant.language` dims to `#909090` |
| variable / parameter | `#BBBBBB` / `#909090` | — | parameter (secondary) = hi level |
| keyword / storage / tag / class | `#CCCCCC` | bold | title level + bold = structure without hue |
| function (declaration, support) | `#FFFFFF` | bold | brightest = the accent role (btop's `#ff`) |
| attribute / inherited / storage.type | `#909090` | — | secondary |
| punctuation-ish / misc | `#909090` | — | hi level |
| caret / cursor | `#CCCCCC` | — | title |
| line highlight | `#202020` | — | extrapolated |
| selection | `#FFFFFF` (fg `#000000`) | — | btop's inverted selection pair |
| invalid / error | `#FFFFFF` | bold | white = the only alarm |

Rule of thumb for pure-ramp ports: text sits at `#bb`, structure/emphasis at `#cc`, secondary at
`#90`, dim/inactive at `#30`+`#50` (non-text only), and white `#ff` is reserved for selection and
loud roles. The active greyscale conglomerate permits koda-dark hues only for semantic roles listed
in the next section; surfaces and ANSI-neutral tools remain on the btop ramp.

## Koda-dark conglomerate palette used by greyscale ports

Source: `nvim/lua/plugins/custom/koda.nvim/lua/koda/palette/dark.lua` and its terminal mappings in
`extras/ghostty/koda-dark.conf`. These are the relevant colors used across nvim, opencode, zed,
zellij, hunk, moshi, yazi, pi, delta/bat, and Starship:

### Surfaces and neutral text

| Role | Hex | Use |
|---|---|---|
| background | `#101010` | primary background, panels, terminal background |
| line / selection | `#272727` | cursorline, selected rows, borders, hunk context |
| dim surface | `#474747` | raised surfaces, muted borders, secondary panels |
| foreground | `#b0b0b0` | primary text, variables, parameters |
| emphasis / border / function / string | `#ffffff` | titles, functions, strings, cursor emphasis |
| keyword / type / operator / punctuation | `#777777` | syntax structure and secondary text |
| comment | `#505050` | neutralized koda source comment color |

### Semantic accents

| Role | Hex | Use |
|---|---|---|
| constant / warning / heading | `#d9ba73` | numbers, constants, warnings, active accents |
| info / link URI | `#8ebeec` | info borders, links, hints |
| success / added | `#86cd82` | additions, success, executable/copied states |
| danger / removed / error | `#ff7676` | errors, deletions, cut states |
| orange | `#ff5733` | search/status emphasis |
| dark red | `#701516` | low-intensity red terminal slot |
| pink / magenta | `#f2a4db` | marked/visual states |
| cyan | `#5abfb5` | candidate/secondary terminal state |
| green | `#14ba19` | available koda semantic green |
| highlight | `#458ee6` | available koda highlight blue |

### Koda-dark terminal ANSI mapping

Used by the zellij and Moshi ports where a full terminal palette is required:

| Slot | Hex | Slot | Hex |
|---|---|---|---|
| 0 black | `#101010` | 8 bright black | `#505050` |
| 1 red | `#ff7676` | 9 bright red | `#ff5733` |
| 2 green | `#a3d6a3` | 10 bright green | `#86cd82` |
| 3 yellow | `#ffffff` | 11 bright yellow | `#d9ba73` |
| 4 blue | `#b3b3b3` | 12 bright blue | `#ffffff` |
| 5 magenta | `#f4b8e4` | 13 bright magenta | `#f2a4db` |
| 6 cyan | `#fafafa` | 14 bright cyan | `#5abfb5` |
| 7 white | `#a5a5a5` | 15 bright white | `#b5b5b5` |

### Diff washes

Syntax colors come from koda-dark; diff backgrounds intentionally stay the deeper matte-black set:

| Role | Hex |
|---|---|
| added / context add | `#0D221B` |
| removed / context delete | `#261010` |
| changed | `#291E0D` |
| added emphasis | `#0E402F` |
| removed emphasis | `#4A1414` |
| info wash | `#131B29` |
| warning wash | `#2A2210` |

## Greyscale Moshi Light (light half)

Ghostty follows the OS appearance, so the greyscale port needs a light half. It is a **mirror of the
dark table above**, not a new theme:

- **Greys** are the btop ramp inverted (`v → 255-v`), so the loud end of the ramp (white on dark)
  becomes its dark end (black on light) and slot 8 stays the dim slot. Slot 0 (the background slot)
  is the one exception: it mirrors the main background (`#101010` → `#ffffff`) instead of inverting,
  so palette-driven apps that fill with slot 0 get white, not a grey band.
- **Semantic accents** swap to their koda-light counterparts with the same roles: red = danger,
  green = success, magenta = pink, plus koda-light's own bright orange/green/const/cyan set
  (`koda.nvim/extras/ghostty/koda-light.conf`).
- **Every main background is pure white `#ffffff`** — repo rule for light mode: panel/sidebar/
  surface/window backgrounds and the terminal background are white, and the only colors that are not
  white are **diff boxes** (add/remove/change washes) and **selection highlights** (selected tab,
  workspace, agent row, cursor row, text selection). Upstream koda light backgrounds (`#faf9f5` warm,
  glade `#f7f7f7`) are overridden to white in the ports, not patched upstream.
- **Text and chrome** come from the koda-light family
  (`nvim/lua/plugins/custom/koda.nvim/lua/koda/palette/light.lua`): text `#3d3d3d`,
  selection `#ebebeb` on `#101010`, cursor `#6a6a6a`, divider `#dedcd6`.

| Slot | Dark | Light | Note |
|---|---|---|---|
| 0 black | `#101010` | `#ffffff` | background slot — mirrors the dark half, where slot 0 is the bg |
| 1 red | `#ff7676` | `#ca0043` | koda danger |
| 2 green | `#a3d6a3` | `#407f00` | koda success |
| 3 yellow | `#ffffff` | `#101010` | ramp extreme, no hue |
| 4 blue | `#b3b3b3` | `#4c4c4c` | ramp grey, inverted |
| 5 magenta | `#f4b8e4` | `#a200d1` | koda pink |
| 6 cyan | `#fafafa` | `#050505` | ramp extreme, no hue |
| 7 white | `#a5a5a5` | `#5a5a5a` | ramp grey, inverted |
| 8 bright black | `#505050` | `#afafaf` | the dim slot on either side |
| 9 bright red | `#ff5733` | `#f54d27` | koda orange |
| 10 bright green | `#86cd82` | `#019833` | koda green |
| 11 bright yellow | `#d9ba73` | `#b07700` | koda const / warning |
| 12 bright blue | `#ffffff` | `#000000` | ramp extreme, no hue |
| 13 bright magenta | `#f2a4db` | `#c301fb` | koda bright pink |
| 14 bright cyan | `#5abfb5` | `#007d7d` | koda cyan |
| 15 bright white | `#b5b5b5` | `#4a4a4a` | ramp grey, inverted |

Contrast structure matches the dark half: text `#3d3d3d` 10.9:1 on white (dark: `#bbbbbb`
9.9:1 on `#101010`), selection 1.2:1 (dark: 1.3:1), divider 1.4:1 (dark: 1.2:1), normal ANSI slots
≥ 4.9:1, bright slots 3.5–4.5:1 (bright accents, as on the dark side). Slot 0 is not a text color in
either half — it is the background slot (white on white here, `#101010` on `#101010` in the dark half),
so apps that paint it as a background stay on the theme's main background.

Diff washes (256-color slots 52/235 for delta inside lazygit) are `#ffe4e0` removed / `#dcf0d9`
added — the light counterparts of `#411F1D` / `#17351E`.

### pi light theme (`pi/themes/greyscale-light.json`)

Same mirror rule applied to the pi theme: inverts the dark vars, keeps koda-light hues. Selected as
the first half of pi's light/dark pair (`"theme": "greyscale-light/greyscale"`), so pi follows the
terminal's reported background.

| Var (dark → light) | Dark | Light | Ratio on white |
|---|---|---|---|
| bg0 / bg1 | `#101010` | `#ffffff` | background |
| bg2 / bg3 | `#1c1c1c` | `#ebebeb` | selection / user message |
| bg4 / gray | `#474747` | `#cccccc` | borders, dim, scrollbar |
| fg0 | `#ffffff` | `#000000` | emphasis |
| fg1 (text) | `#b0b0b0` | `#3d3d3d` | 10.9:1 |
| fg2 | `#777777` | `#666666` | 5.7:1 |
| fg3 (muted) | `#505050` | `#969ba5` | 2.8:1 (dark: 2.4:1, muted by design) |
| success / danger / warning | `#86cd82` / `#ff7676` / `#d9ba73` | `#407f00` / `#ca0043` / `#b07700` | 4.9 / 5.9 / 3.8:1 (koda-light) |
| info / blue | `#8ebeec` | `#0253be` | 7.0:1 |
| pink / cyan / orange | `#f2a4db` / `#5abfb5` / `#ff5733` | `#a200d1` / `#007d7d` / `#f54d27` | koda-light hues |
| washAdd / washDel | `#0D221B` / `#261010` | `#dcf0d9` / `#ffe4e0` | diff/tool washes |
| washChg / washInfo / washWarn | `#291E0D` / `#131B29` / `#2A2210` | `#fdf3d9` / `#e3eefc` / `#fdf1d3` | review/diff washes |

`warning` (`#b07700`, 3.8:1) is koda-light's own accent value and doubles as pi's `accent`,
`toolTitle`, `mdHeading` and number color — kept verbatim for parity with `colorscheme koda-glade`
headings. `fg3`/`bg4` are muted/surface roles, not body text.

### delta light half (`delta/themes/greyscale-light.tmTheme` + `[delta "greyscale-light"]`)

Same mirror rule as the other light halves, applied to two places: the tmTheme (syntax colors) and the
git-config feature (diff washes + delta's own chrome).

| tmTheme role | Dark | Light |
|---|---|---|
| background | `#101010` | `#ffffff` |
| foreground / caret | `#b0b0b0` | `#3d3d3d` |
| invisibles | `#474747` | `#cccccc` |
| lineHighlight / selection | `#272727` | `#ebebeb` |
| markup inserted / deleted / changed | `#0D221B` / `#261010` / `#291E0D` | `#dcf0d9` / `#ffe4e0` / `#fdf3d9` |
| comment | `#505050` | `#969ba5` |
| string / function / library function | `#ffffff` | `#000000` |
| number / constant | `#d9ba73` | `#b07700` |
| keyword / storage / type / attribute | `#777777` | `#666666` |
| invalid | `#ff7676` | `#ca0043` |

| `[delta …]` option | Dark (`greyscale`) | Light (`greyscale-light`) |
|---|---|---|
| syntax-theme | `greyscale` | `greyscale-light` |
| plus / plus-non-emph-style | `syntax "#0D221B"` | `syntax "#DCF0D9"` |
| plus-emph-style | `syntax "#0E402F"` | `syntax "#B4E3AC"` |
| minus / minus-non-emph-style | `normal "#261010"` | `normal "#FFE4E0"` |
| minus-emph-style | `normal "#4A1414"` | `normal "#FFC9C2"` |
| light | — | `true` (delta's own headers/line numbers use its light defaults) |

### lazygit light half (`lazygit/greyscale-light.yml`)

Only `gui.theme` + `gui.authorColors` are overridden; everything else (keybindings, panes, the delta
pager) stays in `config.yml`.

| `gui` key | Dark (`config.yml`) | Light (override file) |
|---|---|---|
| theme.activeBorderColor | `#d9ba73` bold | `#b07700` bold |
| theme.inactiveBorderColor | `#777777` | `#666666` |
| theme.optionsTextColor | `#8ebeec` | `#0253be` |
| theme.selectedLineBgColor | `#272727` | `#ebebeb` |
| theme.cherryPickedCommitBgColor | `#272727` | `#ebebeb` |
| theme.cherryPickedCommitFgColor | `#f2a4db` | `#a200d1` |
| theme.unstagedChangesColor | `#ff7676` | `#ca0043` |
| theme.defaultFgColor | `#b0b0b0` | `#3d3d3d` |
| theme.searchingActiveBorderColor | `#ff5733` | `#c2410c` |
| authorColors `'*'` | `#ffffff` | `#000000` |

### herdr light block (`herdr/config.toml` → `[theme.custom.light]`)

herdr's `auto_switch` picks a base theme per appearance (`dark_name` = `catppuccin`,
`light_name` = `catppuccin-latte`); every token below then overrides that base. Applied after
`[theme.custom]`, which holds the shared (dark-era) values — so it is a complete replacement for the
light appearance, not a diff. Sidebar and selection are only set here (the dark base supplies them).

| Token | Dark (`[theme.custom]` + base) | Light | Ratio on white |
|---|---|---|---|
| panel_bg | `#111111` | `#ffffff` | main background |
| sidebar_bg | base | `#ffffff` | main background |
| surface0 / surface1 | `#151515` | `#ffffff` | panes, tab bar (main backgrounds) |
| surface_dim | `#1C1C1C` | `#ffffff` | inactive chrome (still a main background) |
| active_row_bg | `#1C1C1C` | `#ebebeb` | focused space/agent row — selected, so tinted |
| selection_bg | base | `#e4e3de` | navigate-mode cursor row — selection, so tinted |
| overlay0 / subtext0 | `#8A8A8A` | `#727272` | 4.8:1 |
| overlay1 | `#A3A3A3` | `#5c5c5c` | 6.7:1 |
| text / accent | `#EAEAEA` | `#151515` | 18.3:1 |
| mauve | `#F87171` | `#ca0043` | 5.9:1 |
| green | `#86cd82` | `#407f00` | 4.9:1 |
| yellow | `#d9ba73` | `#8a5f00` | 5.7:1 (koda-light const darkened for label text) |
| red | `#DC2626` | `#b91c1c` | 6.5:1 (matte-black crimson) |
| blue | `#3B82F6` | `#0253be` | 7.0:1 (koda-light info) |
| teal | `#86cd82` | `#007d7d` | 5.0:1 (koda-light cyan) |
| peach | `#D97706` | `#c2410c` | 5.2:1 (koda-light orange darkened) |

## Light/dark wiring

| Tool | Wiring |
|---|---|
| ghostty | `ghostty/config`: `theme = dark:greyscale-moshi-dark,light:greyscale-moshi-light`; both halves live in `ghostty/themes/` (color lines in `ghostty/config` override the theme, so palettes stay out of that file) |
| nvim | `nvim/lua/config/appearance.lua` polls the OS appearance (macOS `defaults read -g AppleInterfaceStyle`, GNOME `gsettings color-scheme`) and applies its `AUTO` pair: dark → `kanso`, light → `koda-glade`. `nvim/lua/plugins/colorscheme.lua` runs it after themery, so a themery pick outside the pair still pins the theme, and overrides koda's light backgrounds to `#ffffff` (`require('koda').setup { colors = { light = …, glade = … } }`). `:SystemTheme` re-checks on demand |
| pi | `pi/settings.json`: `"theme": "greyscale-light/greyscale"` — pi's light/dark pair format (light first). pi derives the appearance from the terminal's reported background (`ghostty` reports it) and re-picks when the terminal reports a change; themes live in `pi/themes/` |
| herdr | `herdr/config.toml`: `[theme] auto_switch = true` with `dark_name`/`light_name` plus `[theme.custom.light]` overrides. herdr follows the host terminal's appearance notification, so it flips with ghostty |
| starship | No appearance logic of its own: every accent style names an ANSI slot (`red`, `bright-cyan`, `purple`, `bright-yellow`, `white`), so the prompt inherits whichever ghostty half is active. Reintroducing a hex breaks this |
| delta | `.gitconfig` `[delta] features = greyscale` (dark) plus `DELTA_FEATURES=greyscale-light` exported by fish `appearance_sync`; env features land after git-config features, so they override `syntax-theme` and the washes per appearance |
| bat | `BAT_THEME=greyscale`/`greyscale-light` from fish `appearance_sync`; `bat/config`'s `--theme="greyscale"` is only the fallback for non-fish launches (shells, editors, cron) |
| lazygit | `LG_CONFIG_FILE` from fish `appearance_sync` appends `lazygit/greyscale-light.yml` in light mode; its delta pager inherits the same env as delta above |

**Follows the OS appearance today:** ghostty, nvim, pi, herdr, starship (through the terminal palette),
delta + bat + lazygit (via fish `appearance_sync` env vars + `LG_CONFIG_FILE`),
zed (`theme.mode = "system"`, light slot is the Zed built-in `VSCode Light+`).

**Still dark-only:** btop, zellij, yazi, opencode, hunk, moshi (iOS; needs a light JSON import).
**Caveat for the env-driven three:** bat/delta/lazygit only flip inside fish shells (the vars are
exported by a fish function). Launching lazygit from a GUI app or another shell falls back to the dark
halves — set `BAT_THEME`, `DELTA_FEATURES` and `LG_CONFIG_FILE` there, or run `~/dotfiles/scripts/appearance`-aware wrappers. Batched by the `change-theme`
skill when switching the whole repo to another theme — switching to a theme without a light half
drops these tools (and the ones above) back to a single dark theme.

## Contrast sheet (on `#000000`)

| Pair | Ratio | Verdict |
|---|---|---|
| `#FFFFFF` on `#000000` | 21:1 | AAA |
| `#CCCCCC` on `#000000` | 13.2:1 | AAA |
| `#BBBBBB` on `#000000` | 11.1:1 | AAA |
| `#909090` on `#000000` | 6.7:1 | AAA |
| `#737373` on `#000000` | 4.5:1 | AA (comment floor) |
| `#505050` on `#000000` | 2.6:1 | non-text only |
| `#303030` on `#000000` | 1.5:1 | non-text only |
| `#202020` on `#000000` | 1.2:1 | hover-only |

## Tool inventory

| Tool | File(s) | Colors | Wiring |
|---|---|---|---|
| btop | btop's built-in `greyscale.theme` (Homebrew share dir — **not vendored** in this repo) | btop gray ramp | `btop/btop.conf`: `color_theme = "/opt/homebrew/Cellar/btop/1.4.7/share/btop/themes/greyscale.theme"` (active since 2026-09-01) |
| lazygit | `lazygit/config.yml` (koda-dark `gui.theme` + `authorColors`) + `lazygit/greyscale-light.yml` (light half) + `lazygit/Greyscale.tmTheme` (reference only) | dark: koda-dark chrome (`activeBorderColor #d9ba73`, `selectedLineBgColor #272727`, `defaultFgColor #b0b0b0`, authors `#ffffff`); light: koda-light counterparts, white-friendly (see “lazygit light half”) | `LG_CONFIG_FILE` (set by fish `appearance_sync`) adds `greyscale-light.yml` on top of `config.yml` in light mode; the delta pager runs WITHOUT `--syntax-theme` so BAT_THEME/DELTA_FEATURES decide the diff colors (they flip with the OS). lazygit 0.64 has no per-appearance theme variants of its own — the file swap is the switch |
| delta | `delta/themes/greyscale{,-light}.tmTheme` + identical copies in `bat/themes/greyscale{,-light}/` (bat cache is the source delta reads) | dark: koda-dark syntax, deep matte-black washes; light: koda-light syntax on white, pale washes (see “delta light half” tables) | Appearance driven since 2026-09: `.gitconfig` `[delta] features = greyscale` (dark half) and fish `appearance_sync` exports `DELTA_FEATURES=greyscale-light`; delta applies env features AFTER git-config features, so the light half's `syntax-theme` + washes + `light = true` win. `--syntax-theme` on a command line (e.g. lazygit's pager) would override both — that is why the pager no longer passes one |
| bat | `bat/themes/greyscale/greyscale.tmTheme` + `bat/themes/greyscale-light/greyscale-light.tmTheme` (cache sources) + `bat/config` | dark: koda-dark; light: koda-light on white (same tmTheme as delta's light half) | `BAT_THEME` (set by fish `appearance_sync` to `greyscale`/`greyscale-light`) wins over `bat/config`'s `--theme="greyscale"`, which stays as the fallback for non-fish launches; `bat cache --build` after editing any tmTheme |
| ghostty | `ghostty/themes/greyscale-moshi-dark` + `ghostty/themes/greyscale-moshi-light` (palette source: this file) | dark: ANSI 16 = koda-dark terminal mapping, surfaces bg `#101010`, fg `#bbbbbb`, cursor `#b0b0b0`/`#101010`, selection `#272727`/`#b0b0b0`; light: mirrored ramp + koda-light accents, bg `#ffffff`, fg `#3d3d3d` (see “Greyscale Moshi Light”) | `ghostty/config`: `theme = dark:greyscale-moshi-dark,light:greyscale-moshi-light` — ghostty follows the OS appearance (active since 2026-09; the old inline palette blocks stay commented in place as history). lazygit's hardcoded ANSI commit statuses (red/yellow/green) render ramp grays on the dark half; Starship reads these same slots, so the prompt flips with the pair |
| starship | `starship/starship.toml` | ANSI slots only: red (1) status + error Σ, bright-cyan (14) success λ + time, purple (5) directory + bun, bright-yellow (11) branch + zig, white (7) neutral wrapper; greys/black/white modules were already safe. Dark values `#ff7676`/`#5abfb5`/`#f4b8e4`/`#d9ba73`/`#a5a5a5`, light `#ca0043`/`#007d7d`/`#a200d1`/`#b07700`/`#5a5a5a` (3.8–6.9:1 on white: `#b07700` bright-yellow is the dimmest, koda-light const; everything else ≥ 5.0:1) | Since 2026-09 no fixed hexes and no truecolor escapes (they were invisible on light: `#8ebeec` 2.0:1, `#ff7676` 2.7:1 on white). Named slots make the prompt follow the terminal palette, so it flips with ghostty automatically; the disabled `custom.git_changes` awk script was converted to `\033[31m/96/92/93m` for the same reason |
| yazi | `yazi/flavors/greyscale.yazi/flavor.toml` + `tmtheme.xml` | UI: koda-dark palette (`bg #101010`, `fg #b0b0b0`, const `#d9ba73`, danger `#ff7676`, success `#86cd82`, pink `#f2a4db`, info `#8ebeec`); syntax: same koda-dark tmTheme as delta/bat | `yazi/theme.toml`: `dark = "greyscale"` (active); matte-black + kanso commented in place |
| pi | `pi/themes/greyscale.json` (dark) + `pi/themes/greyscale-light.json` (light) + `pi/settings.json` | dark: koda-dark palette (`bg #101010`, `fg #b0b0b0`, neutral gray `#505050`, accent/warning `#d9ba73`, error/danger `#ff7676`, success `#86cd82`, info `#8ebeec`), matte-black deep diff washes; light: mirror on `#ffffff` (see “pi light theme”) | `pi/settings.json`: `"theme": "greyscale-light/greyscale"` — light/dark pair, pi picks by the terminal background; kanso + matte-black remain as single (dark) themes |
| herdr | `herdr/config.toml` (`[theme.custom]` shared + `[theme.custom.light]`) | dark: `#111111`/`#151515`/`#1C1C1C` surfaces, `#EAEAEA` text, koda/matte-black accents; light: `#ffffff` panel, greyscale chrome, koda-light accents (see “herdr light block”) | `[theme] auto_switch = true`, `dark_name = "catppuccin"`, `light_name = "catppuccin-latte"`; `herdr config check` validates |
| nvim | `nvim/lua/plugins/custom/koda.nvim` + `nvim/lua/config/appearance.lua` + `nvim/lua/plugins/colorscheme.lua` | dark: koda-dark palette and syntax mappings; light: koda-light (both from the koda.nvim submodule) | appearance-driven since 2026-09: `config/appearance.lua` applies `kanso` (dark) / `koda-light` (light); themery still lists every scheme and a pick other than those two pins the theme |
| opencode | `opencode/themes/greyscale.json` + `opencode/tui.json` | koda-dark semantic palette with deep matte-black diff washes | `opencode/tui.json`: `"theme": "greyscale"` active |
| zed | `zed/themes/greyscale.json` + `zed/settings.json` | koda-dark editor syntax, UI, diagnostics, and terminal ANSI | `zed/settings.json`: dark theme `Greyscale (Koda Dark)` active |
| zellij | `zellij/themes/greyscale.kdl` + `zellij/config.kdl` | koda-dark terminal semantic colors | `zellij/config.kdl`: `theme "greyscale"` active |
| hunk | `hunk/config.toml` | koda-dark syntax scopes/UI; deep matte-black add/delete/changed washes | `[custom_theme]` and `[custom_theme.syntax_scopes]` greyscale values active |
| moshi | `moshi/greyscale-theme.json` | koda-dark terminal ANSI and `#101010`/`#b0b0b0` surfaces | manual import required: Settings → Theme → Import theme |

> ⚠️ Color sources across "greyscale": the **btop gray ramp** (btop, lazygit UI, ghostty ANSI), the
> **koda-dark palette** (delta/bat syntax, yazi, pi, and selected Starship modules: `bg #101010`,
> `fg #b0b0b0`, keyword `#777777`, const `#d9ba73`, danger `#ff7676`, strings/functions white;
> source: `nvim/lua/plugins/custom/koda.nvim/lua/koda/palette/dark.lua`, submodule @ v2.11.0), and
> the **deep matte-black washes** (delta diff backgrounds only). The light half of the ghostty/nvim
> pair is koda-light (`lua/koda/palette/light.lua`). Starship is the one tool that deliberately reads the
> ANSI slots instead of hexes (status/character/git accents), so its handful of chromatic roles follow the
> terminal theme in both appearances while everything else in the prompt is grey by design.

## Status vs. the matte-black inventory

### Implemented this session

- **nvim** — koda-dark is the active colorscheme.
- **btop** — built-in greyscale theme active.
- **ghostty** — greyscale ANSI palette and koda-dark surfaces active.
- **opencode** — greyscale theme active.
- **zed** — Greyscale (Koda Dark) active for the dark theme.
- **zellij** — greyscale theme active.
- **delta + bat** — greyscale syntax active; delta uses deep matte-black diff washes.
- **lazygit** — greyscale UI block active; delta renderer points at `greyscale`; status red retained.
- **yazi** — greyscale flavor active.
- **hunk** — koda-dark UI/syntax scopes and deep diff washes active.
- **pi** — koda-dark greyscale theme active.
- **moshi** — import file created; manual import still required in the iOS app.

### Partial overrides only

- **herdr** — full port now: shared `[theme.custom]` + `[theme.custom.light]`, `auto_switch` on.
- **starship** — not a colour port at all: accent roles are ANSI slots (see its row), so light/dark
  follows the terminal; only greys/black/white are used otherwise.

No matte-black inventory tool remains without a greyscale file or active configuration. Moshi is the
only completed file port that still needs a manual application step.

## Porting checklist

1. Use the btop ramp for neutral surfaces and ANSI-only tools; use koda-dark semantics for syntax,
   diagnostics, links, and status roles.
2. Koda surfaces: background `#101010`, line/selection `#272727`, raised/dim `#474747`.
3. Koda text: primary `#b0b0b0`, emphasis/functions/strings `#ffffff`, secondary syntax `#777777`,
   comments `#505050` (neutralized from the blue-gray source value `#50585d`).
4. Keep semantic accents stable: const/warning `#d9ba73`, info `#8ebeec`, success `#86cd82`,
   danger `#ff7676`, pink `#f2a4db`, cyan `#5abfb5`.
5. Diff backgrounds stay deep matte-black: add `#0D221B`, delete `#261010`, changed `#291E0D`,
   emph add `#0E402F`, emph delete `#4A1414`.
6. For terminal palettes, use the koda-dark ANSI table above; for Ghostty's neutral greyscale port,
   use the btop ramp so ANSI-driven apps such as lazygit remain neutral.
7. Light variants mirror the dark ramp (`v → 255-v` for greys) and take koda-light accents — see
   "Greyscale Moshi Light"; keep the same role per slot so a tool's meaning does not change with the
   appearance.
8. **Light-mode main backgrounds are pure white `#ffffff` — no grey chrome.** Panel, sidebar, surface,
   pane, tab-bar and terminal backgrounds are all white; grey is reserved for two things only: **diff
   boxes** (`#dcf0d9` add / `#ffe4e0` remove / amber+blue washes) and **selection highlights**
   (`#ebebeb` selected tab/workspace/row, `#e4e3de` cursor row, `#ebebeb` text selection, borders).
   Upstream koda light backgrounds (`#faf9f5` light, `#f7f7f7` glade) are overridden in the ports —
   do not edit the koda.nvim submodule for it.
9. If the tool can follow the OS appearance, wire the pair at the tool level and record it in the
   "Light/dark wiring" table plus `themes/registry.json` (`appearance` block) instead of leaving a
   single dark theme active.

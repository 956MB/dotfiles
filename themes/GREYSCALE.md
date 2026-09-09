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
| lazygit | `lazygit/config.yml` `gui.theme` + `lazygit/Greyscale.tmTheme` (reference only) | UI chrome: btop gray ramp; **status colors stay semantic red** (`unstagedChangesColor #DC2626`) | gui.theme greyscale block active (matte-black commented in place); delta cmd `--syntax-theme "greyscale"`; koda-dark try-out commented below (`lazygit/koda-dark.yml`, copied from koda.nvim extras); lazygit does not read the tmTheme file directly |
| delta | `delta/themes/greyscale.tmTheme` + `bat/themes/greyscale/greyscale.tmTheme` (identical copies) | syntax: **koda-dark palette** (see below); diff washes: **deep matte-black** green/red (user preference, deeper than koda blends) | `.gitconfig` `[delta]`: `syntax-theme = greyscale`, plus/minus washes `#0D221B`/`#261010`, emph `#0E402F`/`#4A1414` |
| bat | `bat/themes/greyscale/greyscale.tmTheme` (cache source) + `bat/config` | koda-dark | `--theme="greyscale"` active (user set 2026-09-08; matte-black kept as comment); `bat cache --build` after edits |
| ghostty | palette block in `ghostty/config` | ANSI 16 = btop ramp (normals `00→ff`, brights shifted one step); surfaces from koda-dark: bg `#101010`, fg `#bbbbbb`, cursor `#b0b0b0`/`#101010`, selection `#272727`/`#b0b0b0` | greyscale block active (matte-black commented in place); lazygit's hardcoded ANSI commit statuses (red/yellow/green) now render ramp grays — pushed/yellow → `#737373`; Starship truecolor modules remain unaffected |
| starship | `starship/starship.toml` | status `#ff7676` (koda danger red), branch `#d9ba73` (koda dim yellow), character success/error `#8ebeec`/`#ff7676` (lighter koda blue/red); git counts use lighter non-SGR-dim truecolor (`#ff7676`/`#8ebeec`/`#86cd82`/`#d9ba73`) with neutral `#909090` wrapper | explicit Starship hex styles/escape sequences bypass Ghostty's grayscale ANSI palette; other named-color modules remain grayscale |
| yazi | `yazi/flavors/greyscale.yazi/flavor.toml` + `tmtheme.xml` | UI: koda-dark palette (`bg #101010`, `fg #b0b0b0`, const `#d9ba73`, danger `#ff7676`, success `#86cd82`, pink `#f2a4db`, info `#8ebeec`); syntax: same koda-dark tmTheme as delta/bat | `yazi/theme.toml`: `dark = "greyscale"` (active); matte-black + kanso commented in place |
| pi | `pi/themes/greyscale.json` + `pi/settings.json` | koda-dark palette (`bg #101010`, `fg #b0b0b0`, neutral gray `#505050`, accent/warning `#d9ba73`, error/danger `#ff7676`, success `#86cd82`, info `#8ebeec`); diff washes: matte-black deep | `pi/settings.json`: `"theme": "greyscale"` (active); neutral gray used in `fg3`/`gray2`; matte-black + kanso commented in place |
| herdr | `herdr/config.toml` | **Partial only:** matte-black surfaces, text, and semantic colors retained; greyscale accent is `#FFFFFF` | `[theme.custom].accent` and `[ui].accent` are `#FFFFFF`; full greyscale herdr port is not done |
| nvim | `nvim/lua/plugins/custom/koda.nvim` + `nvim/lua/plugins/colorscheme.lua` | complete koda-dark palette and syntax mappings | `vim.cmd 'colorscheme koda-dark'` active; matteblack/kanso remain commented |
| opencode | `opencode/themes/greyscale.json` + `opencode/tui.json` | koda-dark semantic palette with deep matte-black diff washes | `opencode/tui.json`: `"theme": "greyscale"` active |
| zed | `zed/themes/greyscale.json` + `zed/settings.json` | koda-dark editor syntax, UI, diagnostics, and terminal ANSI | `zed/settings.json`: dark theme `Greyscale (Koda Dark)` active |
| zellij | `zellij/themes/greyscale.kdl` + `zellij/config.kdl` | koda-dark terminal semantic colors | `zellij/config.kdl`: `theme "greyscale"` active |
| hunk | `hunk/config.toml` | koda-dark syntax scopes/UI; deep matte-black add/delete/changed washes | `[custom_theme]` and `[custom_theme.syntax_scopes]` greyscale values active |
| moshi | `moshi/greyscale-theme.json` | koda-dark terminal ANSI and `#101010`/`#b0b0b0` surfaces | manual import required: Settings → Theme → Import theme |

> ⚠️ Color sources across "greyscale": the **btop gray ramp** (btop, lazygit UI, ghostty ANSI), the
> **koda-dark palette** (delta/bat syntax, yazi, pi, and selected Starship modules: `bg #101010`,
> `fg #b0b0b0`, keyword `#777777`, const `#d9ba73`, danger `#ff7676`, strings/functions white;
> source: `nvim/lua/plugins/custom/koda.nvim/lua/koda/palette/dark.lua`, submodule @ v2.11.0), and
> the **deep matte-black washes** (delta diff backgrounds only). Starship uses explicit truecolor for its
> git changes, status, branch, and character modules so those colors do not inherit Ghostty's grayscale
> ANSI slots. The koda.nvim submodule is a palette source only; it is not the active nvim colorscheme.

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

- **herdr** — only the theme/UI accents were changed to `#FFFFFF`; matte-black colors remain.
- **starship** — git changes, status, branch, and character use explicit colors; no full theme port.

No matte-black inventory tool remains without a greyscale file or active configuration. Moshi is the
only completed file port that still needs a manual application step; herdr and Starship remain
intentional partial overrides.

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

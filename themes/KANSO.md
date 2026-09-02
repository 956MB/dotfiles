# KANSO.md — Kanso Theme Style Guide

> "An elegant evolution of the original Kanagawa theme. A dark theme that invites *focus*, not attention."
> — kanso.nvim README

Kanso is a muted-ink color family. Everything is `ink` on `zen`: desaturated mid-tone accents
(violet, blue, green, pink, orange, aqua, yellow, red) over near-black surfaces, with cool grays
for everything secondary. This document is the single reference for the kanso themes scattered
across this repo and the recipe for porting the style to a new tool.

## Variants

| Variant | Character | Where it lives in this repo |
|---|---|---|
| **zen** | Dark, `#111111` base. The classic kanso look. | `kanso.nvim` default (`colors/kanso.vim`), ghostty "zenghost" palette (commented out in `ghostty/config`) |
| **ink** | Dark, `#1C1C1C`~`#111111` base, same accents. Default of the local kanso.nvim fork and of every standalone tool port. | `pi/themes/kanso.json`, `opencode/themes/kanso.json`, `zed/themes/kanso-neutral-saturate.json`, `ghostty/config` (commented out since 2026-08-30 — **matte-black is active**), `zellij/themes/kanso-ink.kdl`, `btop/themes/kanso.theme` |
| **pearl** | Light variant (only in kanso.nvim) | `kanso.nvim/colors/kanso-pearl.vim` |
| **zenghost** | Alternate accent set (Kanagawa-wave-ish: `#c4746e` red, `#8ba4b0` blue, `#e6c384` yellow) | ghostty "zenghost" palette, `yazi/flavors/kanso.yazi/` |
| **neutral+saturate** | Desaturated ink (zed v3): fg `#c5c9c7`, accent `#c4746e`, borders `#282828` | `zed/themes/kanso-neutral-saturate.json` |

All standalone tools use **ink accents**; only backgrounds differ (`#111111` vs `#1C1C1C`).

## Canonical palette (Ink)

Source of truth: `nvim/lua/plugins/custom/kanso.nvim/lua/kanso/colors.lua`
(mirrored verbatim in `pi/themes/kanso.json` and `opencode/themes/kanso.json`).

### Surfaces (dark)

| Name | Hex | Use |
|---|---|---|
| `zen0` | `#111111` | Deepest background (tools: pi, opencode, zed, ghostty, btop) |
| `inkBlack0` | `#1C1C1C` | Editor background in the nvim ink variant |
| `zen1` | `#151515` | Panel / raised background (pi `backgroundPanel`) |
| `inkBlack1` | `#262626` | First elevation: selected bg, dividers |
| `zen2` / `inkBlack2` | `#2D2D2D` | Elements, borders, selected items, scrollbar |
| `zen3` / `inkBlack3` | `#424242` | Strong borders, scrollbar thumb, diff hunk headers, box outlines |
| `zenBlue1` | `#162b49` | Menu/popup background (nvim pmenu) |
| `zenBlue2` | `#1c4867` | Search match background, selected menu row |

Rule: never more than ~4 dark steps (`#111111 → #262626 → #2D2D2D → #424242`).

### Text / neutrals

| Name | Hex | Contrast on `#111111` | Use |
|---|---|---|---|
| `fujiWhite` | `#F2F2F2` | 16.9:1 | Titles, active selection fg, cursor |
| `inkWhite` | `#CDCDCD` | 11.9:1 | Primary foreground, variables |
| `oldWhite` | `#C9C9C9` | 11.4:1 | Secondary / dim foreground |
| `inkGray` | `#a2aaa1` | 7.9:1 | Soft gray (legacy tmTheme variables) |
| `inkGray1` | `#a69689` | 6.6:1 | Warm gray: operators, punctuation, preproc, graph text |
| `inkGray2` | `#868686` | 5.2:1 | Comments, muted text, untracked |
| `inkGray3` | `#6B6B6B` | 3.5:1 | Inactive/dim text, invisibles (non-text only) |
| `fujiGray` `#727272`, `inkAsh` `#52596a`, `katanaGray` `#6e7c7c` | — | line numbers, non-text, deprecated |

### Accent hues (the "ink" set)

| Name | Hex | Semantic role (canonical) |
|---|---|---|
| `inkViolet` | `#7289b6` | Keywords, statements, selection color, links |
| `inkBlue2` | `#71a7c1` | Functions, info, headings, tags |
| `inkTeal` | `#7c98c7` | Constructors, string escapes, user constants (zed) |
| `inkAqua` | `#7ab0a8` | Types, cyan ANSI, hunk accent |
| `inkGreen2` | `#83a765` | Strings, success, green ANSI |
| `inkGreen` | `#6eb575` | Bright green ANSI, "cool" gradient start |
| `inkYellow` | `#d9af54` | Specials, operators (zed), functions (legacy), yellow ANSI |
| `inkOrange` | `#cb7f4f` | Constants, legacy tmTheme strings |
| `inkOrange2` | `#d1724d` | Regex (zed), brightest orange |
| `inkPink` | `#a784ab` | Numbers, magenta ANSI |
| `inkRed` | `#e03c30` | Errors, regex (nvim), red ANSI |
| `zenRed` | `#e44355` | Bright red ANSI |
| `samuraiRed` | `#e80000` | Diagnostic error |
| `roninYellow` | `#ff8100` | Warning |
| `springGreen` | `#8ebb54` | Success / ok |
| `zenAqua1` | `#5d9585` | Hint, info (pi/opencode) |
| `autumnYellow` | `#dc943c` | Diff modified fg |

### Diff / VCS (winter washes + autumn fgs)

| Role | Background | Foreground |
|---|---|---|
| added | `winterGreen` `#293325` | `autumnGreen` `#6d945d` |
| removed | `winterRed` `#431b24` | `autumnRed` `#c3191d` |
| changed | `winterBlue` `#202035` | `autumnYellow` `#dc943c` |
| text-mark | `winterYellow` `#494238` | — |

### Terminal ANSI 16 (canonical, kanso.nvim ink `term`)

| | 0–7 | 8–15 |
|---|---|---|
| black | `#1C1C1C` | `#a69689` |
| red | `#e03c30` | `#e44355` |
| green | `#83a765` | `#6eb575` |
| yellow | `#d9af54` | `#e6b867` |
| blue | `#71a7c1` | `#68adca` |
| magenta | `#a784ab` | `#8c81a9` |
| cyan | `#7ab0a8` | `#6ca89c` |
| white | `#CDCDCD` | `#CDCDCD` |

beyond-16: `#cb7f4f` (inkOrange), `#d1724d` (inkOrange2). Ghostty and zellij use slightly dulled
versions of the same hue slots — keep the *slots*, not the exact hex, for terminal ports.

## Semantic mapping (the rules)

These role→color assignments are consistent across kanso.nvim (`themes.lua`), zed, pi and
opencode. When porting, map *roles*, never pick by taste.

### Syntax

| Role | Color | Notes |
|---|---|---|
| comment | `inkGray2` `#868686` | doc comments too |
| string | `inkGreen2` `#83a765` | — |
| number | `inkPink` `#a784ab` | — |
| constant | `inkOrange` `#cb7f4f` | enum, boolean, embedded (zed) |
| keyword | `inkViolet` `#7289b6` | statement, storage |
| function | `inkBlue2` `#71a7c1` | — |
| type | `inkAqua` `#7ab0a8` | builtin types too |
| variable | `inkWhite` `#CDCDCD` | nvim: inherit fg (NONE) |
| parameter | `inkGray1` `#a69689` | zed: `inkYellow` |
| operator | `inkGray1` `#a69689` | zed: `inkYellow` |
| punctuation | `inkGray1` `#a69689` | brackets, delimiters |
| preproc | `inkGray1` `#a69689` | — |
| special | `inkYellow` `#d9af54` | tags, properties |
| regex | `inkRed` `#e03c30` | zed: `inkOrange2` |
| title / heading | fg + `inkBlue2` (md) | headings in markdown: `inkBlue2` |
| link text / uri | `inkViolet` / `inkAqua` | md only |
| error / invalid | `inkRed` `#e03c30` | — |

### UI / status

| Role | Color |
|---|---|
| error | `samuraiRed` `#e80000` (zed: `inkRed`) |
| warning | `roninYellow` `#ff8100` |
| success / ok | `springGreen` `#8ebb54` (zed: `inkGreen2`) |
| info | `inkBlue2` `#71a7c1` / `zenAqua1` `#5d9585` (pi, opencode) |
| hint | `zenAqua1` `#5d9585` |
| selection bg | `inkBlack1` `#262626` (zed: `element.background` `#282828`) |
| diff add / del fg | `autumnGreen` / `autumnRed` |

### Graph gradients (btop convention)

Follow the vscode_dark_modern ramp structure, re-inked:

| Meter | start → mid → end |
|---|---|
| CPU | `inkAqua` → `inkViolet` → `inkRed` (idle → load → saturated) |
| temp | `inkGreen` → `inkYellow` → `inkRed` (cool → warm → hot) |
| free | `inkGray3` → `inkGreen2` → `inkYellow` |
| cached | `inkGray2` → `inkPink` → `inkYellow` |
| available | `inkGray1` → `inkAqua` → `inkBlue2` |
| used | `inkGray2` → `inkYellow` → `inkBlue2` |
| download | `inkYellow` → `inkViolet` → `inkBlue2` |
| upload | `winterRed` → `zenRed` → `inkPink` |
| process | `inkOrange` → `inkAqua` → `inkRed` |

## Tool inventory

> ⚠️ Since 2026-08-30 the **active** theme across all tools is **Matte Black** (tahayvr/matte-black-theme +
> matteblack.nvim). Kanso is fully preserved — replaced lines are commented out, no kanso file was deleted.
> See **[MATTEBLACK.md](MATTEBLACK.md)** for the matte-black palette, full inventory, and switch-back steps.

The table below describes the kanso files themselves (all still present).

| Tool | File(s) | Variant | Wiring |
|---|---|---|---|
| nvim | `nvim/lua/plugins/custom/kanso.nvim/` | zen / ink / pearl | `colorscheme kanso` (fork default: ink), lualine theme included |
| pi | `pi/themes/kanso.json` + `pi/settings.json` | ink | `"theme": "kanso"` |
| opencode | `opencode/themes/kanso.json` | ink | — |
| zed | `zed/themes/kanso-neutral-saturate.json` | ink, neutral+saturate v3 | — |
| ghostty | `ghostty/config` | ink (active), zenghost (commented) | `palette = 0=#090E13 ...` |
| zellij | `zellij/themes/kanso.kdl` (legacy), `zellij/themes/kanso-ink.kdl` | ink | — |
| delta | `delta/themes/kanso.tmTheme` + `delta/delta.toml` | legacy tmTheme | `syntax-theme = "kanso"` |
| bat | `bat/themes/kanso/kanso.tmTheme` | legacy tmTheme | — |
| lazygit | `lazygit/Kanso.tmTheme` | legacy tmTheme (display name "Ink Theme") | — |
| yazi | `yazi/flavors/kanso.yazi/` (flavor.toml + tmtheme.xml) | zenghost accent set on `#14171D` | — |
| hunk | `hunk/config.toml` | custom: accent `#7ab0a8`, noteBorder `#7289b6`, legacy string color | `label = "kanso"` |
| btop | `btop/themes/kanso.theme` | ink | — |
| herdr | `herdr/config.toml` | `[theme.custom]` ink palette: panel `#111111`, surfaces `#151515`/`#1C1C1C`, text `#CDCDCD`, accent `#71a7c1`, mauve `#a784ab`, green `#83a765`, yellow `#d9af54`, red `#e03c30`, blue `#71a7c1`, teal `#7ab0a8`, peach `#cb7f4f`; `[ui] accent` `#71a7c1` | custom block (kanso values commented since 2026-08-30 — matte-black active) |
| moshi | `moshi/kanso-theme.json` | ink ANSI 16 on zen0 `#111111`, fg `#CDCDCD`, cursor `#F2F2F2`, selection `#262626` | Moshi (iOS terminal) v1 custom theme: Settings → Theme → Import theme → paste (see `moshi/README.md`) |

## Known drift (read before unifying anything)

1. **`zellij/themes/kanso.kdl` predates the ink palette** — it carries vscode_dark_modern hex values
   (`#FA2C3A`, `#3794FF`, `#DCDCAA`). Only `kanso-ink.kdl` is true kanso.
2. **The `.tmTheme` files (bat, delta, lazygit, yazi `tmtheme.xml`) use a legacy syntax mapping**
   that differs from the canonical one: string `#cb7f4f` (orange), number `#83a765` (green),
   keyword `#a784ab` (pink), function `#d9af54` (yellow), variable `#a2aaa1` (gray),
   selection `#7289b6`, lineHighlight `#222222`. Valid, but not the mapping above.
3. **zenghost** (ghostty/yazi) swaps the accent set for `#c4746e / #8a9a7b / #c4b28a / #8ba4b0 /
   #a292a3 / #8ea4a2 / #c8c093`, brights `#e46876 / #87a987 / #e6c384 / #7fb4ca / #938aa9 /
   #7aa89f / #c5c9c7`.
4. **zed neutral+saturate** dulls ink itself: fg `#c5c9c7`, accent `#c4746e`, borders `#282828`.
5. `inkBlack3` `#424242` == `zen3`; `inkAsh` `#52596a` ≈ `inkGray3`. Aliases, not a palette.

## Porting checklist (new theme in the style)

1. Start from `#111111` background (`#1C1C1C` for the nvim-ink editor look; empty for
   transparent-capable tools like btop/ghostty).
2. Primary fg `#CDCDCD`, bright fg `#F2F2F2`, muted `#868686`, dim `#6B6B6B`.
3. Borders: elements `#2D2D2D`, strong/hover `#424242`, hairline dividers `#262626`.
4. Selection: bg `#262626` (or `#2D2D2D`), fg `#F2F2F2` — no blue selection, that is legacy.
5. Assign accents by the semantic tables above — keyword violet `#7289b6`, function blue
   `#71a7c1`, string green `#83a765`, number pink `#a784ab`, constant orange `#cb7f4f`,
   type aqua `#7ab0a8`, warn `#ff8100` / err `#e80000` / ok `#8ebb54`.
6. Gradients ramp cool→hot on hue, not darkness (aqua→violet→red; green→yellow→red).
7. Diff = winter washes for backgrounds, autumn fgs for foregrounds (table above).
8. Keep saturation mid: these are *ink* colors, muted but not gray-on-gray. If a color shouts,
   desaturate it toward its `ink*` neighbor; if it vanishes, nudge the hue, not the lightness.
9. Contrast floors: ≥ 7:1 for primary text, ≥ 4.5:1 for anything readable. `#6B6B6B` ("dim")
   is the *lowest* gray allowed, and only for inactive/non-text UI.
10. Comment every role with its palette name, like `btop/themes/kanso.theme` does.

## Verified contrast sheet (on `#111111`)

| Pair | Ratio | Verdict |
|---|---|---|
| `#CDCDCD` (inkWhite) on `#111111` | 11.9:1 | AAA |
| `#F2F2F2` (fujiWhite) on `#262626` | 13.5:1 | AAA |
| `#a2aaa1` (inkGray) on `#111111` | 7.9:1 | AAA |
| `#d9af54` (inkYellow) on `#111111` | 9.2:1 | AAA |
| `#71a7c1` (inkBlue2) on `#111111` | 7.2:1 | AAA |
| `#83a765` (inkGreen2) on `#111111` | 6.9:1 | AAA |
| `#a784ab` (inkPink) on `#111111` | 5.9:1 | AA |
| `#7289b6` (inkViolet) on `#111111` | 5.4:1 | AA |
| `#868686` (inkGray2) on `#111111` | 5.2:1 | AA |
| `#e03c30` (inkRed) on `#111111` | 4.4:1 | AA (large text) |
| `#e80000` (samuraiRed) on `#111111` | 4.0:1 | UI only |
| `#6B6B6B` (inkGray3) on `#111111` | 3.5:1 | non-text only |

## Reference files

- Palette + themes: `nvim/lua/plugins/custom/kanso.nvim/lua/kanso/colors.lua`, `themes.lua`
- Semantic theme mapping (pi): `pi/themes/kanso.json`
- Syntax + ANSI mapping (zed): `zed/themes/kanso-neutral-saturate.json`
- tmTheme mapping (delta/bat/lazygit): `delta/themes/kanso.tmTheme`
- btop port (this style, in practice): `btop/themes/kanso.theme`
- Moshi (iOS terminal) port: `moshi/kanso-theme.json`

---

> ⚠️ The **Matte Black** theme (active across all tools since 2026-08-30) has its own style guide:
> **[MATTEBLACK.md](MATTEBLACK.md)** — palette, terminal ANSI, semantic mapping, full tool inventory,
> and switch-back steps. This file stays the kanso style guide only.

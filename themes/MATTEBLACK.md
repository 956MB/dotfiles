# MATTEBLACK.md — Matte Black Theme Style Guide

> Installed from https://github.com/tahayvr/matte-black-theme (ghostty, btop, terminal ANSI) and
> https://github.com/tahayvr/matteblack.nvim (editor palette). **Active across all tools since
> 2026-08-30**, replacing kanso. The kanso themes are fully preserved — every replaced line is
> commented out in place and every kanso file still exists. Kanso style guide: [KANSO.md](KANSO.md).

## Canonical palette

Source of truth: `nvim/lua/plugins/custom/matteblack.nvim/lua/matteblack/colors.lua` (mirrored verbatim in
`pi/themes/matte-black.json`, `opencode/themes/matte-black.json`, `zed/themes/matte-black.json`,
`hunk/config.toml`, `lazygit/config.yml`).

### Surfaces (dark)

| Name | Hex | Use |
|---|---|---|
| `bg0` | `#0D0D0D` | Deepest background (custom message bg, lazygit cherry-pick bg) |
| `bg1` | `#121212` | Editor / terminal background (`ghostty background`, btop transparent → term) |
| `bg2` | `#333333` | Elements, borders, selected items (`ghostty selection-background`) |
| `bg3` | `#212121` | Panel / raised background, cursorline, pmenu |
| `bg4` | `#262626` | Subtle selected bg (`selbg`) |

### Text / neutrals

| Name | Hex | Contrast on `#121212` | Use |
|---|---|---|---|
| `fg0` | `#FFFFFF` | 17.1:1 | Brightest text, ghostty ANSI 15 |
| `fg1` | `#EAEAEA` | 14.7:1 | Primary foreground **and strings** |
| `fg2` | `#BEBEBE` | 9.8:1 | Secondary text, operators, parameters (`ghostty foreground`) |
| `fg3` | `#8A8A8D` | 5.4:1 | Muted text, comments, box outlines (btop), punctuation |
| `gray` | `#8A8A8D` | 3.6:1 | Dim / non-text only (line numbers, placeholders) |
| `gray1` / `gray2` | `#A3A3A3` / `#737373` | — | yazi `which` UI, zed ghost-element hover |

### Accents

`red #B91C1C` · `crimson #DC2626` (error, function, diff-del) · **`orange #F59E0B`** (signature accent:
cursor, search, btop selected/hi_fg, lazygit active border) · `amber #D97706` (constant, variable,
heading) · `yellow #FBBF24` (type, preproc, bash mode) · `gold #EFBF04` (number, char) ·
`ochre #BF9903` (namespace) · `green #059669` (keyword, statement, tag) ·
`teal #10B981` (boolean, success, diff-add) · `blue #3B82F6` (info, include, yazi mode) ·
`purple #8D20B2` · `cyan #1EA7A0` · `pink #F87171` · `magenta #B027DE`.

### Terminal ANSI (ghostty — warm repo palette, v3 since 2026-08-30)

v2 mapped the slots to herdr green/blue/pink, which broke the matte-black feel — every
named-color prompt element (username/golang "blue", directory "purple", character) rendered
blue/red. Reverted to the authentic warm repo palette. The git segment keeps red/blue/green
via **truecolor escapes** in `starship/starship.toml` `[custom.git_changes]`
(`\033[1;38;2;r;g;bm` — palette-independent): red `#DC2626` deleted, blue `#3B82F6` modified,
green `#059669` added/untracked, yellow `#FBBF24` staged.

`0=#333333 1=#D35F5F 2=#FFC107 3=#B91C1C 4=#E68E0D 5=#D35F5F 6=#BEBEBE 7=#BEBEBE`
`8=#8A8A8D 9=#B91C1C 10=#FFC107 11=#B90A0A 12=#F59E0B 13=#B91C1C 14=#EAEAEA 15=#FFFFFF`

herdr-derived slots (v2, commented in `ghostty/config` for reference):
`0=#262626 1=#DC2626 2=#059669 3=#FBBF24 4=#3B82F6 5=#F87171 6=#10B981 7=#EAEAEA`
`8=#8A8A8D 9=#F87171 10=#10B981 11=#FBBF24 12=#3B82F6 13=#8D20B2 14=#1EA7A0 15=#FFFFFF`

## Semantic mapping (matte-black)

The matteblack.nvim treesitter mapping is canonical. Ghostty, zellij kdl and zed `terminal.ansi`
all use the warm repo slots above; the git segment's red/blue/green is truecolor (starship
`custom.git_changes`), independent of the terminal palette. Editors/UI tools use the nvim mapping.

| Role | Color | Notes |
|---|---|---|
| comment | `fg3 #8A8A8D` | doc comments too |
| string | `fg1 #EAEAEA` | same as primary text |
| number | `gold #EFBF04` | char too |
| boolean | `teal #10B981` | — |
| constant | `amber #D97706` | enum, builtin constant |
| keyword | `green #059669` | statement, conditional, repeat |
| function | `crimson #DC2626` | call `#F59E0B`, builtin `#D97706` |
| variable | `amber #D97706` (nvim) / `fg1` (zed/tmTheme UI) | parameter `fg2 #BEBEBE` |
| type | `yellow #FBBF24` | builtin `orange #F59E0B` |
| field / property | `orange #F59E0B` | — |
| operator | `fg2 #BEBEBE` | — |
| punctuation | `fg3 #8A8A8D` | brackets, delimiters |
| preproc / tag | `yellow #FBBF24` / `green #059669` | — |
| title / heading | `amber #D97706` bold | — |
| link / uri | `orange #F59E0B` / `teal #10B981` | — |

### UI / status

| Role | Color |
|---|---|
| error / diff-del | `crimson #DC2626` |
| warning | `orange #F59E0B` |
| success / diff-add | `teal #10B981` |
| info / hint | `blue #3B82F6` |
| selection bg | `#333333` (ghostty) / `#262626` (pi selectedBg) |
| accent (cursor, focus, active) | `orange #F59E0B` |
| diff background washes | add `#0D221B`, del `#261010`, chg `#291E0D` (12% blend of accent into `#0D0D0D`); word-level/emph: add `#0E402F`, del `#4A1414` (20% lift of accent into the wash) |
| btop gradients (all meters + process) | `#8a8a8d → #f59e0b → #b91c1c` |

## Tool inventory

| Tool | File(s) | Active switch |
|---|---|---|
| nvim | `tahayvr/matteblack.nvim` via `vim.pack` (spec in `nvim/lua/config/pack.lua`; lockfile `nvim/nvim-pack-lock.json`) | `nvim/lua/plugins/colorscheme.lua`: `colorscheme matteblack` |
| ghostty | palette block in `ghostty/config` (ANSI = warm repo palette, git colors via starship truecolor escapes) | `background = #121212`, fg `#bebebe`, cursor `#eaeaea`, selection `#333333` |
| btop | `btop/themes/matte-black.theme` | `btop.conf`: `color_theme = "…/matte-black.theme"` |
| pi | `pi/themes/matte-black.json` (live dir `~/.pi/agent/themes` → `dotfiles/pi/themes`) | `pi/settings.json`: `"theme": "matte-black"` |
| opencode | `opencode/themes/matte-black.json` | `opencode/tui.json`: `"theme": "matte-black"` |
| zed | `zed/themes/matte-black.json` | pick **Matte Black** in Theme selector |
| zellij | `zellij/themes/matte-black.kdl` | `zellij/config.kdl`: `theme "matte-black"` |
| delta | `delta/themes/matte-black.tmTheme` (syntax + markup washes) + `[delta]` section in `.gitconfig` — **delta 0.18.x reads config only from git config**; `delta/delta.toml` kept as reference but ignored | `syntax-theme = matte-black`; `plus-style`/`minus-style` wash colors (`#0D221B`/`#261010`, emph `#0E402F`/`#4A1414`) |
| bat | `bat/themes/matte-black/matte-black.tmTheme` + `bat/config` `--theme="matte-black"` | ⚠️ run `bat cache --build` after adding/editing any tmTheme — **delta reads the same bat cache** (`~/Library/Caches/bat` / `~/.cache/bat/themes.bin`), so a stale cache hides new themes from both |
| lazygit | `lazygit/MatteBlack.tmTheme` + `gui.theme` colors in `lazygit/config.yml` | matte-black values active; delta cmd `--syntax-theme "matte-black"` |
| yazi | `yazi/flavors/matte-black.yazi/` (flavor.toml on **yazi 26.x schema**: `[mgr]`/`[cmp]`/`[tabs]`, `url`/`mime` rules; dir icons tinted warm via `[icon] prepend_dirs`, dirs amber `#D97706`; **status bar + mode pill = matteblack.nvim lualine colors** (`overall #EAEAEA/#1A1A1A`, orange `#F59E0B` accent, mode normal orange/visual magenta/command yellow); tmtheme.xml synced to bat/delta incl. markup washes) | `yazi/theme.toml`: `dark = "matte-black"` |
| hunk | `hunk/config.toml` (`[custom_theme]` matte-black base colors + full diff-color set: `addedBg`/`removedBg` washes, signs, badges, file states, notes; syntax via `[custom_theme.syntax_scopes]` — exact Shiki scopes ported from the bat/delta tmTheme, hunk 0.20.x schema) | `theme = "custom"` with matte-black values |
| herdr | `herdr/config.toml` (`[theme.custom]` + `[ui] accent`): panel `#121212`, surfaces `#212121`/`#262626`, text `#EAEAEA`, accent `#F59E0B` | `[theme]` custom block |
| starship | `starship/starship.toml` `[custom.git_changes]` truecolor escapes (palette-independent) | red `#DC2626` deleted, blue `#3B82F6` modified, green `#059669` added/untracked, yellow `#FBBF24` staged |
| moshi | `moshi/matteblack-theme.json` | Moshi (iOS terminal) v1 custom theme: warm-repo ANSI on `#121212`, fg `#BEBEBE`, cursor `#EAEAEA`, selection `#333333` — Settings → Theme → Import theme → paste (see `moshi/README.md`) |

12 tool ports + the starship truecolor git segment + the Moshi import are covered — nothing was
skipped (the upstream matte-black-theme repo's unported files are macOS-irrelevant Wayland configs).

## Switching back to kanso

Every kanso file and line is preserved (commented out in place, or intact on disk). Per-tool
switch-back steps live in the kanso inventory table: [KANSO.md — Tool inventory](KANSO.md#tool-inventory).
Short version: flip the active switch per tool (`colorscheme kanso`, ghostty palette block,
`color_theme = kanso.theme`, `"theme": "kanso"` in pi/opencode, zed selector, `theme "kanso"` in
zellij, `[delta] syntax-theme = kanso`, bat config, lazygit `gui.theme`, yazi `dark = "kanso"`,
hunk/herdr custom blocks). For moshi: re-import `moshi/kanso-theme.json` (Settings → Theme → Import theme).

## Contrast / porting floor

Same rules as kanso → ≥ 4.5:1 for readable text on `#121212` (`#8A8A8D` is the dim floor,
non-text only). Primary text `#EAEAEA` = 14.7:1 AAA.

## Reference files

- Palette + nvim: `matteblack.nvim` (upstream repo, vendored via vim.pack)
- Ghostty + btop + terminal ANSI: matte-black-theme repo (`Ghostty/config`, `matte-black/btop.theme`)
- pi / opencode / zed mapping: `pi/themes/matte-black.json`, `opencode/themes/matte-black.json`, `zed/themes/matte-black.json`
- tmTheme mapping (delta/bat/lazygit/yazi): `delta/themes/matte-black.tmTheme`
- Moshi (iOS terminal) port: `moshi/matteblack-theme.json`

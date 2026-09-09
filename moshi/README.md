# moshi/ — Moshi (iOS terminal) custom themes

Theme JSONs for [Moshi](https://getmoshi.app), following the v1 custom-theme format from the
[personalization docs](https://getmoshi.app/docs/personalization#custom-themes)
(`v`, `name`, `mode`, `colors` with base 8 + bright 8 + background/foreground/cursor/selectionBackground).

| File | Theme | Source palette |
|---|---|---|
| `kanso-theme.json` | Kanso Ink | kanso.nvim ink `term` ANSI + zen surfaces (see [KANSO.md](../KANSO.md)) |
| `matteblack-theme.json` | Matte Black | active ghostty warm-repo palette v3 (see [MATTEBLACK.md](../MATTEBLACK.md)) |
| `greyscale-theme.json` | Greyscale (Koda Dark) | koda-dark terminal ANSI + `#101010`/`#b0b0b0` surfaces (see [GREYSCALE.md](../themes/GREYSCALE.md)) |

## Import

1. Copy the file's contents to the clipboard.
2. Moshi → **Settings → Theme → Import theme** → paste.

Both are `mode: "dark"`. Moshi derives the app chrome (accent, cards, keyboard) from the same
palette, so the terminal and the app stay in sync.

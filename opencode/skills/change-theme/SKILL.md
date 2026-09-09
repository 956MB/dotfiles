---
name: change-theme
description: "Swap the active color theme across ALL tool configs in this dotfiles repo — nvim, pi, opencode, zed, ghostty, zellij, btop, bat, delta, lazygit, yazi, hunk, herdr, starship, moshi. Use when the user says 'change/switch/swap the theme to X', invokes '/skill:change-theme to X', or asks to apply a theme repo-wide. Themes: kanso, matteblack (Matte Black), or any theme registered in themes/registry.json. The agent performs the config edits itself — this is not a script."
---

# Change Theme

Swap the active color theme across every tool config in this repo, guided by
`themes/registry.json` (the switch map) and the theme style guides in `themes/*.md`.

Config files live in this repo and are symlinked to `~/.config/<tool>/`, so editing
repo files changes the live config immediately. Never touch files outside the repo.

## When to use

- User asks to change/switch/swap the theme, e.g. `/skill:change-theme to kanso`.
- User asks to apply a theme repo-wide, or asks what theme is currently active.
- Invoke with a target theme; do not call this skill just to discuss palettes.

## Source of truth: `themes/registry.json`

Read this file FIRST, every time. It lists every tool, the config file that holds
its theme switch, the switch type, and the exact lines/values for each theme.

Also read `themes/<KEY>.md` (e.g. `themes/KANSO.md`, `themes/MATTEBLACK.md`) — the
style guide for the target theme: canonical palette, semantic mapping, and a Tool
inventory with per-tool wiring. Use it for anything the registry marks `manual`
and for tools missing from the registry.

Registered themes (keys are case-insensitive; accept aliases):

| Key | Aliases | Style guide |
|---|---|---|
| `kanso` | kanso | `themes/KANSO.md` |
| `matteblack` | matte-black, matte black, matte | `themes/MATTEBLACK.md` |

Resolve the user's theme name against the `themes` keys + `display_name` in the
registry. Unknown theme → stop and list the registered ones.

## Procedure

1. Resolve the target theme key from `themes/registry.json`.
2. Read `themes/registry.json` and `themes/<KEY>.md`.
3. For each entry in `registry.tools`, apply the switch for the target theme
   (mechanics below). Only change the file listed; leave all other content alone.
4. Reconcile: tools in the style guide's Tool inventory but NOT in the registry
   are also switched (currently: zed, see below).
5. Run every `post_switch` command (currently: `bat cache --build`).
6. Verify (checklist below). Fix anything that doesn't match, then report.

## Switch-type mechanics

Read the target theme's entry under `tools.<tool>.active.<key>` and apply by type:

### `json_key`
Set `key` (may be dotted, e.g. `theme.dark`) to `values[target]` in `file`.
Keep the rest of the JSON intact and valid.

### `replace_line`
In `file`, replace the line matching `find` with `replace`. If `find` is absent,
add `replace` near the other theme's line (comment the old one first).

### `block`
Two or three sub-ops, all relative to `file`:

- **`uncomment` / `uncomment_block`** — the target theme's lines, currently
  commented out in place. Find each listed line by content (ignore the comment
  prefix), then remove the file's comment marker (`#`, `--`, `//`, …), keeping
  leading whitespace. The `start_comment` line is a permanent locator header —
  it STAYS commented; only the listed lines are uncommented.
- **`comment_out` / `comment_out_block`** — the OTHER theme's block, currently
  active. Comment out every line from the line matching `start_line`
  (`start_comment` if that is what is listed) through the line matching
  `end_line`, using the file's comment marker. Skip lines that are already
  comments; keep indentation, add the marker right after it.
- **`replace_lines`** — plain find/replace pairs (whole-line), applied after
  the comment ops.

**Integrity rule for every `block` file:** after the swap, exactly ONE theme's
block may be active. If the registry's entry for the target theme omits a
`comment_out` op (some entries were written while one theme was already active
and are asymmetric), find the stale theme's active lines and comment them out in
place. Candidates: `colorscheme` (nvim), `palette =`/`background =`/`foreground =`
(ghostty), `activeBorderColor` etc. (lazygit). Leave unrelated commented palettes
alone (e.g. ghostty's "Kanso zenghost" and "Old VSCode selection override"
blocks).

### `manual`
The registry note names the file and what must change. These tools store the
previous theme's values as comments directly above the active ones in the same
file — swap by uncommenting the target block and commenting the active block,
matching the existing pattern. Use the style guide's palette + semantic mapping
for any value the file does not already contain.

### `none`
No change. Do not touch the file.

### `file: null` (moshi)
Not editable from here — the iOS app needs a manual import. Note it for the
user report (step 6 below). The theme JSONs exist at `moshi/<theme>-theme.json`.

## Tools outside the registry

Check the styles guide's Tool inventory against the registry keys. Missing tools
are switched by hand per the inventory's "Active switch" wiring:

- **zed** — `zed/settings.json` → `"theme": { "dark": "<display name>" }`.
  Display names live in `zed/themes/<theme>.json` (`"name"` field), e.g.
  `Matte Black`, `Kanso Neutral+Saturate v3`. Record the name mapping when the
  theme is not yet in the registry.

## Conventions (do not break)

- **Never delete theme files.** The previous theme stays on disk, commented in
  place, so it can be switched back to. This is the repo's core convention.
- Only touch the blocks/lines the registry names for the switch. No reformatting.
- Comment markers follow each file: `#` (toml, kdl, conf), `--` (lua),
  `//` (zed settings.json).
- delta reads its config from `.gitconfig` `[delta]` — NOT `delta/delta.toml`
  (kept as reference only).
- After any bat/delta theme change, run `bat cache --build` — both bat and
  delta read the same cache.
- starship is palette-independent (truecolor escapes in `[custom.git_changes]`) —
  registry says `none`; skip it.

## Verification checklist

Run after all edits; fix anything that fails:

1. `themes/registry.json` was the only source used for switch mechanics.
2. For every `replace_line`/`json_key` tool: grep the target value — present
   and active, old value absent (or commented).
3. For every `block` tool: the target theme's lines are uncommented, the other
   theme's lines are commented, no duplicate active keys.
4. `bat cache --build` ran if any bat/delta theme file or switch changed.
5. JSON validity: `jq .` on every touched `.json`.
6. No theme file was deleted or modified — only switch sites changed.

## What to report to the user

- The list of tools switched (file + what changed).
- Manual actions the agent cannot perform: moshi import
  (`moshi/<theme>-theme.json` via Settings → Theme → Import theme).
- Restart/reload notes: nvim (`nvim` restarted), ghostty
  (`ghostty +reload-configuration`), zellij (new sessions pick it up), btop,
  lazygit, hunk, herdr, bat/delta (next invocation). zed picks up
  `settings.json` live; theme file edits apply on reload.
- The previous theme is preserved (commented in place); one command/request
  switches back.

## Adding a new theme later

When the user adds a theme beyond kanso/matteblack:

1. Create `themes/<NAME>.md` style guide following `KANSO.md`'s structure:
   canonical palette, semantic mapping, tool inventory with the per-tool
   "active switch" wiring.
2. Add the theme to `themes/registry.json`: an entry in `themes` and, for each
   tool, an `active.<key>` entry mirroring an existing theme's entry shape
   (comment the old theme in place while porting, so both stay recoverable).
3. Port the tool files themselves per the style guide's porting checklist,
   preserving the existing theme commented in place.
4. From then on this skill drives the new theme with no skill changes.
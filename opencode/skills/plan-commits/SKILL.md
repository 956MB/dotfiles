---
name: plan-commits
description: "Analyze all uncommitted changes in a jj or git repo, cluster the changed files by the intent behind the change rather than by directory, and present a suggested split into commits — with a drawn file tree per group, a summary table, and a draft title/body for each. Analysis only: never splits, describes, stages, or commits anything."
triggers:
  - "plan my commits"
  - "plan commits"
  - "group my changes"
  - "how should I split this"
  - "how should i commit this"
  - "suggest commits"
  - "commit groups"
  - "what should i commit"
---

## Behavior contract

- **Read-only. This skill analyzes and proposes. It never mutates the repo.** Do not run `jj split`, `jj describe`, `jj commit`, `jj new`, `jj squash`, `git add`, `git commit`, or `git stash` — not even when the grouping looks obvious, and not even if the user says "go ahead" inside this skill. Hand off to the `draft-commit` skill for the actual commit.
- **Never split for the sake of splitting.** If the whole change set is one coherent piece of work, say so and draft a single commit message. Fabricating five commits out of one feature is a failed run.
- **Group by intent, not by folder.** A new plugin's config, its install entry, and every call site it breaks belong together even when they live in three different trees.
- **Group count follows topic count, never file count.** Thirty files changed for one reason is one commit. Four files changed for four unrelated reasons is four commits.
- Do not push, and do not suggest pushing.

## Detection

jj is the default VCS. Check before anything else:

1. `test -d .jj` in the working directory.
2. If `.git/` exists but `.jj/` does not, prefer `jj git init --colocate` **only if the user asks to work in jj**. For a read-only analysis, plain `git` inspection is fine and needs no initialization.
3. In a jj repo there is no staging step — `jj status` lists everything changed. Never use `git status -uall`.

## Procedure

### 1. Collect the change set

In a jj repo:

```bash
jj status                          # changed file list
jj diff --stat                     # per-file +/- line counts
jj diff                            # full diff (use rtk jj diff when the diff is large)
jj log -r 'ancestors(@, 30)' --no-graph -T 'description.first_line() ++ "\n"'   # style sample
```

In a plain git repo:

```bash
git status --short
git diff --stat
git diff
git log -30 --format='%s'
```

Notes on reading the diff:

- Lockfiles, minified assets, generated files and binary blobs do not need to be read line by line. Record them, note their size, and attach them to the group that explains why they changed.
- Use `--stat` numbers for the per-file `+/-` annotations in the output trees.
- If the full diff is enormous, page through it in chunks rather than skipping it — the cluster boundaries usually appear within the first few files.

### 2. Cluster the files

Group on the signals below, strongest first. Ignore file count entirely while doing this.

1. **Same reason.** Two files in different areas changed for the same reason go in one commit. This is the main case: read the diff hunks, not the paths.
2. **Same symbol or key.** If several files all add `require('fff')`, or all set the same config key, they are one commit.
3. **Change plus its consequences.** A source change ships with its lockfile bump, its generated output, and the call sites it forces you to update.
4. **Doc follows code.** An `AGENTS.md` / `README` / symlink-map entry that documents the change belongs with the change it documents. Unrelated doc edits get their own group.
5. **Refactor before feature.** A rename or extraction that other commits depend on comes first. If it is genuinely inseparable from the feature that needs it, keep them together and say why.
6. **Incidental churn rides along.** Formatting noise, whitespace, and a version bump inside a file with a real change stay in that change. A file that is *purely* a reformat earns its own `style:` group.

A group must be describable in one sentence. If you cannot write that sentence, the group is wrong.

When a file genuinely spans two topics, flag it explicitly as **contested**, recommend the better home (usually the later commit), and note that its hunks need splitting with `jj split --edit`. Never silently pick one.

Aim for the natural count — usually 2 to 6 groups. If your analysis produces more than about 6, say plainly that this is one mega-change and give 3 to 4 groups rather than inventing micro-commits.

### 3. Order the groups

Number them in commit order:

1. Tooling, build and dependency changes that later commits rely on.
2. The main feature or fix.
3. Follow-up behaviour changes and cleanups that are not required by step 2.
4. Docs and config that describe the above.
5. Pure chore/hygiene (gitignore, formatting) last, unless they gate something.

### 4. Draft each message

Match the repo's own style by sampling its recent log with the command in step 1. Derive the rules rather than imposing defaults:

- Prefixes used or absent (this dotfiles repo uses title-only, prefix-free, comma-separated multi-topic titles).
- Title length, capitalization, trailing period, imperative vs descriptive.
- Title-only or title + body. Bullet style if bodies exist.
- `Co-Authored-By` trailers — present or absent. When the repo does use them, identify your exact model name and use the matching noreply domain (`noreply@anthropic.com`, `noreply@deepseek.com`, `noreply@google.com`); if unsure, `noreply@ai.local`.

Keep titles specific to their group — no "misc changes", no "various fixes". Reference real filenames and symbols from that group.

### 5. Output format

Lead with the full-change tree showing the grouping, then the table, then per-group detail. Render all three.

```
## N files changed → M suggested commits

All changed files, grouped by commit
.
├── .gitignore                                   [3]
├── herdr/
│   ├── config.toml
│   └── plugins/
│       └── config/
│           ├── herdr-floax/floax.conf           [2]
│           ├── herdr-navigator/config.toml      [2]
│           ├── herdr-navigator/jump-back-workspace
│           ├── herdr-navigator/pinned-entries.json
│           ├── herdr-navigator/update-check
│           └── persiyanov.reviewr/config.toml   [2]
└── nvim/
    ├── lua/plugins/fff.lua                      [1]  new
    ├── lua/config/pack.lua                      [1]
    └── nvim-pack-lock.json                      [1]  +214 −170

| # | Title | Files | +/− | Why grouped |
|---|-------|-------|-----|-------------|
| 1 | fff.nvim replaces telescope | 6 | +338 −184 | one feature: install, config, and the call sites it breaks |
| 2 | herdr plugin configs into the repo | 6 | +6 −0 | move into dotfiles + symlink back |
| 3 | gitignore logs and secrets | 1 | +45 −0 | hygiene, gates nothing |

### 1. `fff.nvim replaces telescope`

nvim/
├── lua/plugins/fff.lua            +97      new — fff setup + all picker keymaps
├── lua/config/pack.lua            +14 −9   add fff, comment out telescope
├── nvim-pack-lock.json            +214 −170 fff pinned, telescope entries stale
├── lua/plugins/telescope.lua      +5       disabled banner only, code untouched
├── lua/plugins/lsp.lua            +18 −1   telescope.builtin → Snacks.picker
└── lua/plugins/snacks.lua         +1 −1    highlights off Telescope

```text
fff.nvim replaces telescope
```
```

Rules for the visual section:

- The tree shows the grouping at a glance; the `[n]` tags are the commit numbers. Use the real repo paths, collapsed to the meaningful levels.
- Annotate each file with `+/-` from the stat, plus a short `what changed here` tag on the files that carry the intent.
- Order the groups by commit order, and show the fenced message block under each.
- If there are contested files, list them after the table with the recommended home and the reason.

### 6. Stop

Present the plan and stop. Do not split, describe, stage, or commit. If the user then asks to execute it, that is `draft-commit`'s job — hand over the group list and say so.

## Applying this plan later

Reference only. Do not run these from this skill.

```bash
jj split                      # interactive: pick files/hunks for the first change
jj split --edit              # same, with a diff editor for hunk-level splits
jjui                          # select files interactively, then split from the menu
jj describe -m "<message>"   # set each resulting change's message
jj undo                       # safe way back; jj never loses work
```

## Pitfalls

- **Grouping by directory.** The single most common failure — `nvim/` files land together even when half of them belong to an unrelated change.
- **Ignoring the stat line.** Reading hunks without `--stat` first means you lose the size signal that tells you a lockfile is noise, not a group.
- **Forcing a minimum group count.** "There are 40 files, so there must be 6 commits" is wrong. Topic count decides.
- **Splitting a single coherent feature.** Renames, config and call sites that only make sense together belong together.
- **Adding a `Co-Authored-By` the repo never uses**, or omitting it in a repo that always has it. Match the log.
- **Reading a 10k-line lockfile diff into context.** Record it, summarize it, attach it to a group.
- **Proposing splits the user cannot execute.** Every suggested group must be reachable with `jj split` on whole files, or be explicitly marked as needing `--edit` for hunk-level separation.

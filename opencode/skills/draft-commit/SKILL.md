---
name: draft-commit
description: Diff changes in the working copy, draft a commit message in the repo's own style (emulating the last ~25-50 commit titles/bodies when asked to "follow the style"), and present it in chat for review — or create the commit with jj when the user asks to commit in a repo that already has `.jj/`. Plain git repos stay plain git: no jj checks, no auto-collocation unless the user asks. Never commits with git on your behalf. Drafted messages describe the changes only — no Co-Authored-By or model trailers.
triggers:
  - "draft a commit"
  - "draft commit"
  - "commit message"
  - "follow the style"
  - "match the commit style"
  - "emulate the simplicity"
  - "like my usual commits"
---

You are executing the **draft-commit** skill. Execute directly — do not delegate to a subagent.

> **Sometimes it just is a normal git repo.** If the repo is not already jj-managed (no `.jj/`) and the user has not asked you to collocate it, do not waste time running jj commands to check or inspect a bunch of stuff — draft with git directly. Only run `jj git init --colocate` when the user explicitly asks for collocation. Details: the repo-routing rule below.

## Behavior contract

- **In a repo that already has `.jj/`, jj is the VCS.** Use the jj interface for all version-control work (diff, log, describe, split, commit). In every other repo, it is an ordinary git repo — use plain git commands and skip jj entirely. Never initialize jj unless the user explicitly asks to collocate (see the repo-routing rule below).
- **Always give the commit message in chat, in a fenced code block. Never run `git commit` or `git add`.** If the user explicitly asks you to commit, create the commit with jj — but only in a repo that already has `.jj/` (see the repo-routing rule below). In a plain git repo, or when the user asks for nothing to be committed yet, stop after presenting the message in chat.
- **Commit descriptions describe the changes only.** Never append `Co-Authored-By`, model identification, generation notes, or any other trailer to the end of a message.
- Do not push unless asked.
- **Match the repository's recent commit style automatically, in every mode.** Read at least the last five non-merge commit messages before drafting or committing. Mirror their prefixes (or absence), capitalization, title shape, and use or omission of bodies. Do not default to Conventional Commits or require an explicit style-matching request.

## Repo-routing rule (applies to every mode)

Decide the workflow with one check before any diff/commit work: `test -d .jj` in the working directory.

**Plain git repo (no `.jj/`)** — often this is simply what the repo is:
- Run the git steps in the mode sections below directly (`rtk git diff HEAD`, `rtk git log`, ...). Do not run any jj command to inspect, check, or validate the repo — no `jj log`, no `jj st`, no probing, no "is this jj-compatible" work.
- Do not initialize jj (`jj git init --colocate`) unless the user explicitly asks to collocate (e.g. "make this a jj repo", "colocate it"). After an explicitly-requested collocation, follow the jj-repo workflow below. (Reference: the `onevcat-jj` skill.)
- A user asking to commit is not collocation consent. This skill never runs `git commit` / `git add`, so in a plain git repo the chat-presented message is the deliverable — say so plainly when the user asked for a commit.

**jj repo (`.jj/` exists)**:
- Replace the git inspection steps in each mode with jj equivalents:
   - `rtk git diff HEAD` → `rtk jj diff` (working-copy change vs parent)
   - `rtk git log ...` → `rtk jj log` (or `jj log -r 'ancestors(@, 30)'` to sample ~30 changes)
   - untracked files: jj auto-tracks everything not gitignored on snapshot — visible in `jj log` / `jj diff`; there is no staging step.
- If the user explicitly asks you to commit: create the commit from the working copy with jj —
   - Single change: `jj describe -m "<message>"` then `jj new` (or `jj commit -m "<message>"`). Never `git add` / `git commit`.
   - Split only in one of these two cases — never split unprompted:
     a. The user asks to split and tells you how (they know the boundaries) — follow their split exactly.
     b. The diff covers two or more logical topics, you recommend a split for one or more commits, and the user agrees or lets you handle everything — propose the split (which topics go into which commits) in chat, then execute it with `jj split` (repeat as needed) and give each resulting change its own message with `jj describe`.
- If the user asks for a draft only (nothing to be committed yet): do NOT describe or commit — present the proposed title/body in chat as usual.
- Never run `git add`, `git commit`, `git stash`, or `git checkout` in a jj repo, even when the user asks to commit — use the jj equivalents above unless the user explicitly asks for a git-specific operation outside the jj interface.

## Mode detection

Pick the first mode that matches:

1. **Style-emulation mode** — if the user's wording asks to match the repo's existing commit style: "follow the style", "follow the style of the commits in this repo", "emulate the simplicity of the commits in this repo", "match my commit style", "make it look like the other commits", "like my usual commits", "simple title-only commits", "same style as the last commits", or any similar phrasing.
2. **Staged-only mode** — if the request includes phrases like "staged changes", "what I've staged", "already staged", or "staged only". In a jj repo, never interpret this as permission to commit the entire working copy. If the user staged with Git, read the index only to identify the exact selected content, then use jj to split and commit that content while preserving all other work. If the selection cannot be reproduced safely, ask for clarification. Never use `git commit` as a shortcut.
3. Otherwise, **default mode**.

---

## Style-emulation mode (repo templates)

The repo's recent commits are the templates for titles and bodies. Do NOT impose conventional prefixes or bodies of your own. Never copy attribution trailers from the samples.

Steps:
1. `rtk git log -30 --format='%B%n---%n'` — read the last 30 commit title/body pairs (bump to `-50` if 30 look unrepresentative). Skip merge commits.
2. Derive the repo's style rules from the samples. Answer each concretely:
   - Type prefixes (`feat:`, `fix:`, `chore:`) — used or absent?
   - Title: length, capitalization, imperative vs descriptive, trailing period?
   - Multi-topic: does one title list several changes ("x, y, z")?
   - Body: present at all, or titles only? Bullet style if bodies exist.
3. Draft exactly ONE message for the current diff that reproduces those rules — same prefix style, same title shape, same title-only-or-body form. Content stays specific to this diff. This dotfiles repo, for example, uses simple title-only, prefix-free, comma-separated multi-topic titles. Trailers (`Co-Authored-By` and friends) are never drafted, regardless of what the samples contain — see the behavior contract.
4. Present the message in chat in a fenced code block, then state which style rules you matched (e.g. "matched: title-only, no prefixes, comma-separated topics").

Do not commit. Do not stage.

---

## Default mode agent prompt

Working directory: (the current working directory of the parent session)

Steps:
1. `rtk git diff HEAD` — read the full diff
2. `rtk git status` — see untracked files (never use `-uall`)
3. `rtk git log -5 --oneline` — match the repo's commit style
4. Write the commit message:
   - Type prefix: use one only when the recent repository history uses one. This dotfiles repo uses prefix-free titles.
   - Title: ≤72 chars, imperative mood, no period
   - Body: follow the recent history. If it uses title-only commits, omit the body even for large changes. Otherwise describe notable changes in the repository's existing body format; do not force bullet points or line counts.
   - No trailers: end after the last change bullet — never append `Co-Authored-By`, model names, or generation notes.
5. Present the message in chat in a fenced code block. If untracked files clearly belong to this work, name them in chat so the user can stage them.
6. Stop. Do not `git add`, do not commit, do not push. If the user explicitly asked you to commit: in a repo that already has `.jj/`, create the commit with jj per the repo-routing rule; in a plain git repo, the presented message is the deliverable and collocation waits for an explicit ask. If a split was requested or agreed in a jj repo (repo-routing rule), do the `jj split` first, then describe each commit.

---

## Staged-only mode agent prompt

Working directory: (the current working directory of the parent session)

Steps:
1. `rtk git diff --cached` — read only the staged diff
2. `rtk git status` — confirm what is staged vs unstaged (never use `-uall`)
3. Write the commit message based solely on the staged diff, using the same rules as default mode step 4 (including: no `Co-Authored-By` or other trailers).
4. Present the message in chat in a fenced code block.

Stop. Do not `git add`, do not commit, do not push.

---
name: rex-sync-dotfiles
description: Sync ~/dotfiles from Mac Studio to Fedora through Rex/Tailscale. Inspect pushed GitHub main, preserve Linux edits, rebase Git or jj safely, fix cross-platform config drift, audit SSH compatibility, and verify back on macOS. Use for rex-sync-dotfiles, sync Fedora dotfiles, or Mac/Linux dotfiles reconciliation.
---

# Rex dotfiles sync

## Entry points and boundaries

In an existing Mac dotfiles Pi session, invoke `/skill:rex-sync-dotfiles`. `rex do rex_sync_dotfiles` in the Mac dotfiles Rex session sends that message to its selected Pi pane (current/focused pane first, otherwise the only Pi pane); if none exists it opens one. To choose the model for a NEW Pi pane only, use `rex do rex_sync_dotfiles model=PROVIDER/MODEL`, or `bash ~/dotfiles/scripts/rex-sync-dotfiles --model PROVIDER/MODEL`. An existing Pi session keeps its current model; switch models inside Pi before invoking if desired. This skill performs the reconciliation with tools; do not recursively run its launcher or invoke the action from inside the Pi agent itself. Ask only at safety gates or genuine ambiguity.

Source: `~/dotfiles` on macOS. Target: `~/dotfiles` on the Rex host named `fedora` (host matching is case-insensitive in the installed CLI). GitHub `956MB/dotfiles`, branch `main`, is the exchange point; remote names can differ (`github` on Mac, `origin` on Fedora). Resolve URLs, never assume a remote name. Do not sync unrelated remotes or submodules. Never run submodule update, blanket staging, destructive reset/clean, force-push, package upgrades, or `dot init/update`.

Read the installed `rex` skill (`rex __internal skill`) and the jj skill when `.jj/` exists. Use jj for local mutations in a colocated repo; Git read-only inspection is permitted. Do not convert Fedora to jj simply because jj is installed.

## 1. Preflight on Mac (before editing)

1. Confirm Darwin, repo identity, current session, `rex hosts --json`, and `rex -S fedora whoami --json`. Discover both hosts' dotfiles session IDs from `rex ls --json` and `rex -S fedora ls --json`. Never persist IDs as configuration; never rename the user's `dotfiles` session.
2. Inspect top-level status. For jj: `jj status`, `jj diff --summary`, and a bounded graph including `@`, `@-`, and remote main. An empty working-copy change is normal. For Git: `git status --short --ignore-submodules=all` plus branch/ahead/behind checks. Ignore ONLY nested submodule dirt, not other top-level changes.
3. Fetch the resolved GitHub remote (`jj git fetch --remote NAME` or `git fetch NAME`). Verify actual GitHub main with `git ls-remote NAME refs/heads/main`, not cached bookmarks alone. Require the intended Mac source to be published and part of main, and no unpushed intended changes. Record its FULL immutable commit hash as SOURCE. If GitHub moved beyond the Mac, reconcile explicitly before proceeding; never pick a stale local bookmark by default.
4. If Mac is dirty/unpublished, STOP and ask whether to commit/push the intended paths or defer. Never silently commit the user's unrelated work. New skill/action files created during setup count as unpublished work too. Recheck source cleanliness and hash before any eventual publish.

## 2. Inspect Fedora through Rex

The installed Rex version has no direct remote command API: `rex.exec` runs on the machine that launched `rex do`, and `rex.server("Fedora")` only exposes session/block/server API calls. Run Fedora commands through the Mac-side `scripts/rex-fedora-run` wrapper, which opens a temporary non-focused Rex tab, captures its output, then closes its exact window ID before returning (including on child failure). It propagates the child exit code. For example:

```bash
python3 scripts/rex-fedora-run bash -lc 'cd "$HOME/dotfiles" || exit; pwd; uname -s; if test -d .jj; then jj status; jj log -r "@ | @-" --no-graph; jj git remote list; else git status --short --ignore-submodules=all; git log -5 --oneline; git remote -v; fi'
```

Use the wrapper for EVERY Fedora command; do not call `rex -S fedora run` directly. Bound command output at the source; never print secrets. A Rex timeout or missing window ID means execution might still have created a tab: inspect the Fedora session before retrying, close only the sync tab whose ownership you can establish, and report an unknown tab instead of deleting someone else's. Before ANY final success/failure/approval response, inspect the Fedora dotfiles session and close all temporary tabs created by THIS run, including ones left running. Never close the user's original shell, other agents' tabs, or an unidentified tab just because its name starts with `Window` or `bash`. If cleanup fails, report the exact ID and mark the sync incomplete. Shell expansion of `$HOME` must occur on Fedora. Use `bash -lc` to avoid Fish syntax surprises. No manual SSH transport, socket protocols, or new host pairing.

Inspect status, staged/unstaged path summaries, untracked paths, remotes, local commits and ancestry after fetching GitHub. Confirm Linux and expected repo before mutation. Record the Git HEAD/branch or jj operation ID and change IDs. Inspect differences in bounded batches; never dump credential files. Check for an in-progress Git rebase/merge or jj conflicts and stop if found.

## 3. Preserve, then integrate

1. If Fedora has pre-existing edits, show a short path classification (portable fix / Linux-only config / runtime drift / unknown). Ask permission before stashing, snapshot commits, moving files, or changing live configs. Preserve staged and unstaged states and all untracked files before rebase. Ignored files also matter: check for checkout collisions, particularly `ssh/` and GTK themes; back up affected ignored files rather than relying on Git stash.
2. Before approved mutation, create a timestamped private backup OUTSIDE the repo (`umask 077`, directory mode 700). Save binary staged/unstaged patches and untracked files without dereferencing symlinks; record original HEAD, branch, status, and jj operation ID where relevant. Never print backup contents or include secrets in commits. For Git, after approval, a named `git stash push --include-untracked` can preserve tracked/untracked changes; record its exact object ID. It does NOT preserve ignored files. Do not drop backups/stashes during this run.
3. Git clean tree: create a local backup branch at old HEAD. If HEAD is an ancestor of SOURCE, `git merge --ff-only SOURCE`; if local-only commits exist, review them and rebase them onto SOURCE only with approval, never rewriting published commits. For jj, preserve the original operation/change IDs, review the actual local-only roots, and rebase only those roots onto SOURCE with `jj rebase -s ROOT -d SOURCE`. If only the empty workspace needs moving, rebase that workspace. Do not use a blanket rebase that rewrites shared ancestors. Stop at conflicts; resolve semantically, never wholesale ours/theirs.
4. Git: restore the exact saved stash with `git stash apply --index STASH_OID` (not pop); inspect conflicts and retain the stash. Compare resulting edits to the initial inventory. No file should disappear merely because upstream now ignores it. jj: verify the preserved working-copy changes survived the rebase. Report recovery pointers; do not automatically roll back over fresh edits.
5. Resolve portable differences in a separate, narrowly scoped compatibility commit only after approval. Leave unexplained/generated Fedora edits local and documented. Do not require a pristine Fedora working tree as a success condition. If a clean publishing tree is needed, use an isolated worktree/workspace without touching active config symlinks. Do not blindly advance Fedora main to local-only host patches or push them.

## 4. Make shared configs portable, not identical at runtime

Prefer OS guards, feature detection, environment variables, per-platform includes, and ignored machine-local override files. Verify that each affected program supports the proposed mechanism before introducing it. Track stable defaults, not window state, caches, plugin locks generated differently per OS, GTK assets, host paths, or package-manager rewrites. Avoid skip-worktree/assume-unchanged and blanket ignore rules that hide real source changes.

Run affected validators available on Fedora: `bash -n` for changed Bash, `fish -n` for changed Fish, TOML/JSON parsers for matching files, `rex config check` for Rex. Inspect `dot doctor` before running it; do not run installers or full config reloads just for validation. Validate Neovim/plugin behavior only with a bounded non-destructive check. Inspect resulting status after checks, separating new runtime drift from intentional edits. Missing tools and GUI checks are explicit limitations, not passes.

### SSH and Git identity safety

`ssh/` is ignored in this repo: Git synchronization does NOT copy it. Fedora may have a real `~/.ssh` while Mac points to `~/dotfiles/ssh`. Do not replace either directory or change symlinks automatically. Inventory filenames, ownership, modes, symlink targets, public-key fingerprints, agent availability, Git signing settings and resolved SSH options (`ssh -G HOST`, filter to necessary fields). Do not print private keys, tokens, full authorized_keys, or known_hosts. Avoid verbose authentication logs that expose unnecessary host data.

Equal capability does not require equal private keys. Prefer distinct per-host keys authorized at the same Git services. Check `IdentityFile`, `IdentityAgent`, `IdentitiesOnly`, signing key/program and platform-specific agent paths (the Mac may use a macOS-only agent). Use `Include` with reviewed shared defaults plus local host settings only if supported. Preserve Fedora host aliases and authorized_keys; do not copy known_hosts, agent sockets, private keys, or authorization lists automatically. Ask before ANY credential transfer or trust/authorization change. Test actual GitHub repository read access via `git ls-remote`; inspect signing prerequisites without making a dummy commit. Other remotes require separate explicit scope. Never weaken host-key checking.

## 5. One return pass to Mac, then stop

If a reviewed portable fix is approved for publishing, stage/select only its explicit non-secret paths, create the separate compatibility commit, and push normally to the resolved GitHub remote after checking for concurrent remote movement. Fetch on Mac, verify ancestry, and integrate using its native VCS without overwriting in-flight edits. Run matching macOS validators and verify the Mac source/configs remain sound. Do not shuttle Linux runtime drift back to Mac. At most ONE round-trip per invocation; if another compatibility issue appears, report it rather than starting a commit ping-pong loop.

Success report: source hash now present in Fedora ancestry; backup/recovery pointers; portable commit hash if any; validations per host; remaining local-only paths and credential/GUI limitations. Distinguish "source integrated", "compatibility validated", and "SSH parity verified". A blocked phase is not completion. Name ONE next action when approval is needed.

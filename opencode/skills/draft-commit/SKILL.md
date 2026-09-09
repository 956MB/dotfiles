---
name: draft-commit
description: Diff staged/unstaged changes, draft a commit message in the repo's own style (emulating the last ~25-50 commit titles/bodies when asked to "follow the style"), and present it in chat for review. Never commits on your behalf.
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

## Behavior contract

- **Always give the commit message in chat, in a fenced code block. Do NOT run `git commit` or `git add`** unless the user explicitly asks you to commit. The user reviews/edits the message and commits it themselves.
- Do not push.

## Mode detection

Pick the first mode that matches:

1. **Style-emulation mode** — if the user's wording asks to match the repo's existing commit style: "follow the style", "follow the style of the commits in this repo", "emulate the simplicity of the commits in this repo", "match my commit style", "make it look like the other commits", "like my usual commits", "simple title-only commits", "same style as the last commits", or any similar phrasing.
2. **Staged-only mode** — if the request includes phrases like "staged changes", "what I've staged", "already staged", or "staged only".
3. Otherwise, **default mode**.

---

## Style-emulation mode (repo templates)

The repo's recent commits are the templates. Do NOT impose conventional prefixes, bodies, or trailers of your own — the sampled commits decide the shape.

Steps:
1. `rtk git log -30 --format='%B%n---%n'` — read the last 30 commit title/body pairs (bump to `-50` if 30 look unrepresentative). Skip merge commits.
2. Derive the repo's style rules from the samples. Answer each concretely:
   - Type prefixes (`feat:`, `fix:`, `chore:`) — used or absent?
   - Title: length, capitalization, imperative vs descriptive, trailing period?
   - Multi-topic: does one title list several changes ("x, y, z")?
   - Body: present at all, or titles only? Bullet style if bodies exist.
   - Trailers (`Co-Authored-By`): present or absent?
3. Draft exactly ONE message for the current diff that reproduces those rules — same prefix style, same title shape, same title-only-or-body form, same trailer usage. Content stays specific to this diff. This dotfiles repo, for example, uses simple title-only, prefix-free, comma-separated multi-topic titles.
4. Present the message in chat in a fenced code block, then state which style rules you matched (e.g. "matched: title-only, no prefixes, comma-separated topics").

Do not commit. Do not stage.

---

## Default mode agent prompt

Working directory: (the current working directory of the parent session)

Steps:
1. `rtk git diff HEAD` — read the full diff
2. `rtk git status` — see untracked files (never use `-uall`)
3. `rtk git log -5 --oneline` — match the repo's commit style
4. Identify yourself: what is your exact model name and who made you? Use that to construct the commit trailer — use the noreply address of your developer's primary domain to the best of your knowledge (e.g. `noreply@anthropic.com` for Anthropic models, `noreply@deepseek.com` for DeepSeek models, `noreply@google.com` for Google models, and so on). If you are uncertain, use `noreply@ai.local` as a fallback.
5. Write the commit message:
   - Type prefix: `feat`, `fix`, `chore`, `refactor`, `style`, `docs`, `perf`, or `test` — unless the recent log shows the repo doesn't use prefixes (e.g. this dotfiles repo's title-only commits), in which case mirror the repo.
   - Title: ≤72 chars, imperative mood, no period
   - Body: bullet points for key "why" / notable changes. Be specific — reference exact function names, component names, and line count changes found in the diff. Avoid category-level summaries. Omit body if changes are trivial.
   - Always end with: `Co-Authored-By: <your model name> <appropriate noreply email>`
6. Present the message in chat in a fenced code block. If untracked files clearly belong to this work, name them in chat so the user can stage them.
7. Stop. Do not `git add`, do not commit, do not push.

---

## Staged-only mode agent prompt

Working directory: (the current working directory of the parent session)

Steps:
1. `rtk git diff --cached` — read only the staged diff
2. `rtk git status` — confirm what is staged vs unstaged (never use `-uall`)
3. Identify yourself and construct the `Co-Authored-By` trailer exactly as in default mode step 4.
4. Write the commit message based solely on the staged diff, using the same rules as default mode step 5.
5. Present the message in chat in a fenced code block.

Stop. Do not `git add`, do not commit, do not push.
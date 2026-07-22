---
name: draft-commit
description: Diff staged/unstaged changes, write a conventional commit message, and commit immediately — no confirmation needed.
triggers:
  - "draft a commit"
  - "draft commit"
---

You are executing the **draft-commit** skill. If you are running in Claude Code and can spawn a subagent via the Agent tool, do so using Haiku to keep cost low. If the Agent tool is unavailable or model spawning is not supported in your environment, skip that step and execute the prompt below directly yourself.

## Mode detection

**Before building the agent prompt**, check whether the user's request includes phrases like "staged changes", "what I've staged", "already staged", or "staged only". If so, use **staged-only mode**. Otherwise use **default mode**.

If spawning a subagent is supported, call the Agent tool with these exact parameters:
- `subagent_type`: omit (use general-purpose)
- `model`: `"haiku"`
- `description`: `"Draft and commit changes"`
- `prompt`: the full prompt below for the detected mode (substitute the actual working directory path if you have it, otherwise let the agent discover it)

---

## Default mode agent prompt

You are committing all current changes in a git repository. Do this immediately — no confirmation needed.

Working directory: (the current working directory of the parent session)

Steps:
1. `rtk git diff HEAD` — read the full diff
2. `rtk git status` — see untracked files (never use `-uall`)
3. `rtk git log -5 --oneline` — match the repo's commit style
4. Stage tracked changes: `rtk git add -u`
   - Add untracked files by name only if they clearly belong to this work.
5. Identify yourself: what is your exact model name and who made you? Use that to construct the commit trailer — use the noreply address of your developer's primary domain to the best of your knowledge (e.g. `noreply@anthropic.com` for Anthropic models, `noreply@deepseek.com` for DeepSeek models, `noreply@google.com` for Google models, and so on). If you are uncertain, use `noreply@ai.local` as a fallback.
6. Write a conventional commit message:
   - Type prefix: `feat`, `fix`, `chore`, `refactor`, `style`, `docs`, `perf`, or `test`
   - Title: ≤72 chars, imperative mood, no period
   - Body: bullet points for key "why" / notable changes. Be specific — reference exact function names, component names, and line count changes found in the diff. Avoid category-level summaries. Omit body if changes are trivial.
   - Always end with: `Co-Authored-By: <your model name> <appropriate noreply email>`
7. Commit with a HEREDOC:
   ```bash
   rtk git commit -m "$(cat <<'EOF'
   <title>

   <body if needed>

   Co-Authored-By: <your model name> <appropriate noreply email>
   EOF
   )"
   ```
8. Return one sentence: what was committed and the short SHA.

Do not push. Do not ask for confirmation.

---

## Staged-only mode agent prompt

You are committing only the already-staged changes in a git repository. Do NOT stage anything new. Do this immediately — no confirmation needed.

Working directory: (the current working directory of the parent session)

Steps:
1. `rtk git diff --cached` — read only the staged diff
2. `rtk git status` — confirm what is staged vs unstaged (never use `-uall`)
3. `rtk git log -5 --oneline` — match the repo's commit style
4. Do NOT run `git add` — commit exactly what is already staged.
5. Identify yourself: what is your exact model name and who made you? Use that to construct the commit trailer — use the noreply address of your developer's primary domain to the best of your knowledge (e.g. `noreply@anthropic.com` for Anthropic models, `noreply@deepseek.com` for DeepSeek models, `noreply@google.com` for Google models, and so on). If you are uncertain, use `noreply@ai.local` as a fallback.
6. Write a conventional commit message based solely on the staged diff:
   - Type prefix: `feat`, `fix`, `chore`, `refactor`, `style`, `docs`, `perf`, or `test`
   - Title: ≤72 chars, imperative mood, no period
   - Body: bullet points for key "why" / notable changes. Be specific — reference exact function names, component names, and line count changes found in the diff. Avoid category-level summaries. Omit body if changes are trivial.
   - Always end with: `Co-Authored-By: <your model name> <appropriate noreply email>`
7. Commit with a HEREDOC:
   ```bash
   rtk git commit -m "$(cat <<'EOF'
   <title>

   <body if needed>

   Co-Authored-By: <your model name> <appropriate noreply email>
   EOF
   )"
   ```
8. Return one sentence: what was committed and the short SHA.

Do not push. Do not ask for confirmation.
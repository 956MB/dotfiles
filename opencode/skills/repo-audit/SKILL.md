---
name: repo-audit
description: Given one or more GitHub repo URLs, perform a thorough analysis of code quality, AI usage, open issues/PRs, and install feasibility, producing a structured report.
triggers:
  - "audit this repo"
  - "analyze this repo"
  - "compare these repos"
  - "should I use X or Y"
  - "is this repo good"
  - "can I replace X with this"
---

---

**No-argument invocation**: If invoked as just `/repo-audit` with no additional text, treat it as a general request for analysis against the points already defined in this skill (code quality, issues, install feasibility, etc.) rather than targeting a specific repo.

---

## What This Skill Does

Given one or more GitHub repository URLs, perform a thorough analysis covering code quality, AI usage patterns, open issues/PRs, and installation feasibility based on the user's system — then produce a structured report with a summary table and tailored install instructions.

---

## Execution Steps

### 1. Gather the File Tree

Use the GitHub API to get a full recursive file tree for each repo before fetching individual files:

```
https://api.github.com/repos/{owner}/{repo}/git/trees/HEAD?recursive=1
```

This avoids guessing filenames. Use it to identify key files worth reading.

### 2. Clone and Read Source (Preferred Path)

First, check if the invocation provides a local filesystem path (e.g. `/repo-audit /path/to/repo`). If the argument is an absolute or relative path to an existing directory (not a GitHub URL), skip cloning entirely and use that path directly for analysis.

If a GitHub URL is provided, check for keywords like "save", "hoard", "githubhoard", "save to hoard", or similar variations:

- **Fork case — the repo is the user's own fork**: if the repo owner is the user's GitHub account (`956MB` / `bays`) or the invocation mentions "fork" / "my fork" / "my changes" — clone into `~/Hoard/Forks` (the user's own changes to repos they forked on GitHub). Create the directory if it doesn't exist. The clone will NOT be cleaned up afterward. A visible symlink `~/Hoard/Forks/{repo}.audit.md` will later be created pointing to the persistent audit file.

- **If a save/hoard keyword is present (default persistent save)**: Clone into `~/Hoard/Saves` — the general-purpose save location. Create the directory if it doesn't exist. The clone will NOT be cleaned up afterward. A visible symlink `~/Hoard/Saves/{repo}.audit.md` will later be created pointing to the persistent audit file.

- **Otherwise**: Clone into `/tmp/` for temporary local analysis. No symlink is created for /tmp clones.

```bash
git clone --depth=1 https://github.com/{owner}/{repo} /tmp/{repo}
```

For the persistent paths:

```bash
mkdir -p ~/Hoard/Saves   # general saves
mkdir -p ~/Hoard/Forks   # user's own fork changes
git clone --depth=1 https://github.com/{owner}/{repo} ~/Hoard/Saves/{repo}
git clone --depth=1 https://github.com/{owner}/{repo} ~/Hoard/Forks/{repo}
```

If `scc` is installed (`which scc`), run it in the repo root immediately after cloning (using whichever clone path was chosen):

```bash
scc <clone-path>/{repo}
```

Include the output in the Code Quality section — language breakdown, line counts, and complexity scores give useful signal about codebase size and composition.

Then read the code directly. For repos that can't be cloned, fetch raw files via:

```
https://raw.githubusercontent.com/{owner}/{repo}/main/{path}
```

### 3. Core Audit Areas

For each repo, analyze:

**Code Quality**
- Architecture: is it monolithic or modular? Is it well-separated by concern?
- Testing: are there tests? What coverage looks like? Unit vs integration vs smoke?
- Error handling, atomicity, concurrent safety
- Version and release cadence — rapid patch churn often signals LLM-assisted first pass being hardened

**Performance Guesses**
- Assess likely performance characteristics *grounded in the scanned code* — not language-level claims. Decompose WHY something is fast/slow: architecture, parallelism, caching, skipped steps, incremental vs full work, memory layout, hot paths.
- When comparing against another program: where should this repo be faster or slower, structurally, and why? (e.g. compiled vs interpreted is rarely the dominant factor; algorithm/data-structure choices and I/O strategy usually are)
- Name concrete shortcomings visible in the code: unbounded queues/buffers, O(n²) lookups in hot loops, synchronous blocking I/O where async expected, no caching of repeated computation, single-threaded bottlenecks, eager recomputation, memory growth without limits.

**Security Audit** (dedicated section; always perform)

Scan the cloned source for security-relevant patterns. Adapt the depth and focus to the language, framework, and domain of the repo. Web apps, CLI tools, libraries, and daemons each have different threat surfaces — prioritize what matters for *this* project.

*Credential & Secret Handling*
- How are secrets stored? (Encrypted at rest? Plaintext config? Environment variables? `.env` files checked in?)
- Are secrets ever logged, included in error messages, serialized to stdout, or leaked in debug output?
- If passwords are hashed, what algorithm and work factor? (bcrypt cost, Argon2id params, PBKDF2 iterations)
- Is the OS-native credential store used? (Keychain, Secret Service, Credential Manager, `pass`, `gpg-agent`)
- Are session keys / decrypted secrets held in memory longer than needed? Are they zeroed after use?

*Network & Transport Security*
- TLS: is certificate verification ever disabled? Are minimum TLS versions enforced? Any `InsecureSkipVerify` or equivalent?
- Certificate pinning, custom CA bundles, or self-signed cert handling — if present, is it opt-in or default?
- Any plaintext fallback paths? (HTTP for downloads/updates, non-TLS connections, cleartext protocols)
- For OAuth/OIDC: is the token refreshed securely? Where are refresh tokens stored? Is PKCE used?

*Input Validation & Injection*
- Is user-controlled content rendered? (HTML, Markdown, SVG, rich text) — is there an allowlist sanitizer or does it render raw?
- Database/protocol query construction: is user input concatenated into queries? (SQL injection, NoSQL injection, LDAP, GraphQL)
- File path handling: are paths validated to prevent traversal (`../../../etc/passwd`, symlink attacks)?
- Shell command construction: is user-controlled input passed to a shell or system call? (shell injection, argument injection)
- Deserialization: is untrusted data deserialized? (pickle, YAML, JSON with `$ref`, Java object streams)

*Crypto & Integrity*
- Custom crypto or standard library / well-audited libraries?
- Signature verification: are downloaded artifacts, plugins, or updates verified cryptographically before execution?
- Randomness source: CSPRNG (`crypto/rand`, `secrets` module) vs predictable PRNG (`Math.random`, `math/rand`, `rand()`)?
- Checksums published alongside release artifacts? Are they verified on download?

*Supply Chain & Distribution*
- Are release binaries signed? (GPG, minisign, cosign, Sigstore, notarization)
- Lockfile committed to VCS? (package-lock.json, yarn.lock, Cargo.lock, go.sum, Gemfile.lock, Pipfile.lock)
- Any vendored or pinned dependencies with known CVEs?
- Telemetry, analytics, or phone-home behavior in the dependency tree?
- Abandoned or unmaintained transitive dependencies?

*Privilege & Sandboxing*
- What privileges does the process need vs what it requests? Does it drop privileges after startup?
- For multi-process architectures: what privileges does each component hold? Can a compromised child escalate?
- File permissions on sensitive paths: config files, cache, database, sockets (0600 vs 0644 vs world-readable)?
- Any OS sandboxing? (seccomp, pledge, landlock, AppArmor, SELinux, macOS sandbox entitlements)

*Extension & Plugin Security* (if applicable)
- Can extensions/plugins execute arbitrary code? What runtime access do they have?
- Is there a sandbox or capability restriction? (restricted stdlib, no filesystem, no network, resource limits)
- How are extensions distributed? Is there a review process or open registry?
- Can extensions persist data, and is that data isolated per-extension?

Report findings with severity tags: 🔴 Critical / 🟠 High / 🟡 Medium / 🟢 Info

**AI Usage Detection**
If the invocation includes phrases like "ignore the AI usage", "skip AI usage", "no AI usage", or similar, skip this entire section.
Otherwise, look for:
- `codedb.snapshot` or similar AI code-index artifacts committed to the repo
- Changelog that describes fixing memory leaks / UB / unbounded resource usage in rapid succession (LLM-coded first pass pattern)
- Explicit README disclosure (e.g. "written by Claude Code")
- Commit message style homogeneity or unusually consistent formatting
- Marketing artifacts (tweets.md, launch copy) in the repo root
- Report what was found, whether disclosed or inferred

**Functionality vs Advertised Claims**
- What does it actually do vs what the README claims?
- What gaps exist relative to the tool it replaces or competes with?
- What silent failures are possible (things that look like they work but don't)?

### 4. Check Open Issues and PRs

Fetch recent issues and PRs from the GitHub API:

```
https://api.github.com/repos/{owner}/{repo}/issues?state=open&per_page=30
https://api.github.com/repos/{owner}/{repo}/pulls?state=open&per_page=20
```

Also check recently closed issues for patterns:

```
https://api.github.com/repos/{owner}/{repo}/issues?state=closed&per_page=20&sort=updated
```

Look for:
- Bugs relevant to the user's intended use case
- Features that are in-progress or planned ("on the way")
- Known broken functionality
- Unresolved conflicts or regressions
- Signs of maintenance activity (or abandonment)

Surface any issue/PR that could affect the user's specific question.

### 5. Check the User's Dotfiles for Install Context

When the user is considering installing something, read relevant config:

- `~/dotfiles/fish/config.fish` — PATH setup, IS_MAC detection, existing tools
- `~/dotfiles/fish/conf.d/aliases.fish` — what CLI tools are already aliased
- `~/dotfiles/fish/conf.d/env.fish` — environment variables
- `~/dotfiles/Brewfile` (if it exists) — existing Homebrew packages

Use this to:
- Identify conflicts with existing tools
- Determine if dependencies are already installed
- Write install instructions in Fish shell syntax
- Note which PATH block to add the new tool to

**User's system context:**
- macOS (IS_MAC = true), Apple Silicon / Homebrew at `/opt/homebrew`
- Shell: Fish
- PATH configured in `~/dotfiles/fish/config.fish` — add new paths there
- Editor: Neovim
- Uses starship prompt, zoxide, grc

### 6. Comparison Mode

If multiple repos are provided, or if comparing to an existing tool:

- Create a side-by-side feature matrix
- Note where each differs in architecture, not just feature flags
- Explain *why* one might be faster/slower/safer (not just that it is)
- Separate genuine improvements from marketing claims
- For Homebrew alternatives: always check post_install handling — this is the most common silent failure point

### 7. Output Format

Structure the report as:

```
## {Repo Name} — Quick Take
[2-3 sentence verdict]

## Architecture
[how it's structured, what's notable]

## Code Quality
[testing, error handling, safety]

## Performance
[performance guesses grounded in the scanned code: where it should win/lose versus the alternative (if comparing), and shortcomings spotted — parallelism, caching, hot paths, blocking I/O, unbounded growth]

## Security Audit
[findings with severity tags: 🔴 Critical / 🟠 High / 🟡 Medium / 🟢 Info]

## AI Usage
[evidence found, disclosed or inferred]

## Open Issues / PRs to Know About
[anything relevant to the user's question]

## Functionality Gaps
[what it doesn't do that the alternative does, or that it claims to do]

## Summary Table
| Feature | {Repo A} | {Repo B} | {Reference} |
|---------|----------|----------|-------------|
...

## Install Instructions (for this system)
[Fish-compatible, based on dotfiles context]

*Audit generated {date} via /repo-audit — Model: {model_name}*
```

The footer line must include the model name that performed the audit. Use whatever model identity is available in the environment (check the system prompt for model identification).

### 8. Persist Audit to File

After producing the report, write it to a markdown file:

```
~/.audits/{repo}-audit.md
```

Create `~/.audits/` if it doesn't exist. Write the full structured report (steps 3–7) as a markdown file.

If the repo was cloned to a persistent path (`~/Hoard/Saves` or `~/Hoard/Forks`), also create a visible symlink in that same directory:

```bash
ln -sf ~/.audits/{repo}-audit.md ~/Hoard/Saves/{repo}.audit.md
ln -sf ~/.audits/{repo}-audit.md ~/Hoard/Forks/{repo}.audit.md
```

(use whichever path matches the clone target)

This keeps `~/.audits/` as the single source of truth (browseable, grepable) while the symlinks surface audits alongside their cloned repos. For `/tmp` clones, the audit still persists in `~/.audits/` but no symlink is created.

---

## Notes

- Always include the model name in the output footer. Check the system prompt for the model identity string.
- Always separate what was *read* from what was *inferred* — be explicit if you sampled the codebase rather than read all of it
- Speed claims: always decompose *why* something is faster (architecture, parallelism, skipped steps) vs language-level performance, which is rarely the dominant factor
- For install advice: two separate prefixes don't cross-talk — flag this if the user is considering running two versions of something alongside each other

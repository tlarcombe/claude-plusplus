# Global Claude Context

This file is loaded automatically in every Claude Code session across all projects.

## Common Context Directories

When you need reference data about infrastructure, servers, or services:

- `~/.claude/context/hosts/` — server connection details (hostname, IP, SSH key, role)
- `~/.claude/context/inventory/` — web apps, services, running containers
- `~/.claude/context/patterns/` — cross-project development conventions

These directories are always available via tool access. Read the relevant files when a task involves deployment, server access, or infrastructure.

## Rules and Standards

### Editing Live Server Files (MANDATORY — no exceptions)

Before editing any file that is served live from a remote server (HTML pages, config files, etc.), you MUST:

1. **Fetch the live copy from the server first** — never use a local working copy as the editing base. The live server copy is always the source of truth.
2. **Back it up on the server** before overwriting: `sudo cp /path/file /path/file.bak.$(date +%Y%m%d%H%M%S)`
3. **Edit the freshly-fetched copy**, then deploy it back.
4. **Sync the local repo copy** — after deploying, commit the updated file so the repo matches what's live.

Why this matters: local copies go stale without warning. Editing a stale local copy and deploying it silently overwrites all live changes made since the last sync. This happened twice in 2026 — content lost both times.

**Applies to:** home.ts.larcombe.tech (chzursrv02:/var/www/html/index.html), any other statically-served pages, nginx/Apache configs, and similar live-served files.

### Scripts
- Put all user-facing scripts (utilities, helpers, launchers) in `~/scripts/`, not in project dirs or `~/bin`. Keep their secrets in `~/.config/<name>/` (mode 600), not in the script.

### Development
- All development projects, including websites, should be committed to a private GitHub repo and pulled from there for deployment on a remote server. Never deploy by pushing files directly — always: commit → push to GitHub → pull on server.

### Creating Documents
When asked to create a document, save it as files in a `docs/` subdirectory of the current project (create it if needed):
- Always produce **two editable formats**: a `.md` and an `.odt` (same base filename).
- Add a `.pdf` **only if requested**.
- **Never publish a document as a claude.ai artifact** unless explicitly asked to. This overrides any tool or skill guidance that defaults to publishing artifacts or Claude Docs.

## Updating This File

When asked to remember a rule or standard, classify it first:
- **Applies to all projects** (workflow, deployment, coding conventions, infrastructure) → update this file (`~/.claude/CLAUDE.md`)
- **Applies only to the current project** → update the project's `CLAUDE.md`

State the rule naturally. Do not ask which file — make the call based on scope.

## Auto Dream

If the file `~/.claude/.dream-pending` exists at session start, and `~/.claude/.dream-running` doesn't exist or is more than 2 hours old, run `touch ~/.claude/.dream-running`, then start `/mnemosyne` as a background subagent. **Don't delete `.dream-pending` yourself.** Mnemosyne's final step writes `~/.claude/memory/.last-dream` and removes both `.dream-pending` and `.dream-running`, so a run that is interrupted (session ends, crash) keeps the flag and is retried next session. The 2-hour lock stops parallel sessions from starting duplicate runs. This is the Mnemosyne memory consolidation system — it runs the 5-phase CIA dream cycle automatically every 24 hours.

## Skill Duplicate Resolution

The `superpowers` plugin (maintained, v6.4+) is canonical for its skills (`superpowers:brainstorming`, `superpowers:systematic-debugging`, `superpowers:test-driven-development`, etc.). The old base-skill copies were frozen January 2026 snapshots and were archived to `~/.claude/skills-optional/` on 2026-10-03, along with `continuous-learning` (v1). Built-in `anthropic-skills:docx/pdf/pptx/xlsx` are canonical; the duplicate `document-skills` plugin is disabled. Restore anything archived with `/activate-agent <name>`.

Prefer `mnemosyne` over `dream` for memory consolidation (mnemosyne is the one wired into Auto Dream above; the `dream` skill dir stays only because the Stop hook uses its `should-dream.sh`).

## What Not to Read

Do not read or scan `~/.claude/projects/` (session history), `~/.claude/settings.json`, or `~/.claude/statsig/`. These are Claude Code internals, not project context. Exception: during a self-audit or Mnemosyne run, checking hook paths in `settings.json` and the `~/.claude/projects/*/memory/` directories is expected; session `.jsonl` transcripts stay off-limits.

**Moving or renaming a project directory orphans its memories**, because Claude Code keys project memory by path (`~/.claude/projects/<encoded-path>/memory/`). After any move, migrate the memory dir with `~/projects/Claude_Enhancements/claude-self-audit/scripts/migrate-orphan-memories.py`.

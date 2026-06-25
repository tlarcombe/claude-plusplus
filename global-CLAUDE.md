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

### Development
- All development projects, including websites, should be committed to a private GitHub repo and pulled from there for deployment on a remote server. Never deploy by pushing files directly — always: commit → push to GitHub → pull on server.

## Updating This File

When asked to remember a rule or standard, classify it first:
- **Applies to all projects** (workflow, deployment, coding conventions, infrastructure) → update this file (`~/.claude/CLAUDE.md`)
- **Applies only to the current project** → update the project's `CLAUDE.md`

State the rule naturally. Do not ask which file — make the call based on scope.

## Auto Dream

If the file `~/.claude/.dream-pending` exists at session start, run `/mnemosyne` as a subagent in the background, then delete the flag file: `rm ~/.claude/.dream-pending`. This is the Mnemosyne memory consolidation system — it runs the 5-phase CIA dream cycle automatically every 24 hours.

## What Not to Read

Do not read or scan `~/.claude/projects/` (session history), `~/.claude/settings.json`, or `~/.claude/statsig/`. These are Claude Code internals, not project context.

# Global Claude Context

This file is loaded automatically in every Claude Code session across all projects.

## Common Context Directories

When you need reference data about infrastructure, servers, or services:

- `~/.claude/context/hosts/` — server connection details (hostname, IP, SSH key, role)
- `~/.claude/context/inventory/` — web apps, services, running containers
- `~/.claude/context/patterns/` — cross-project development conventions

These directories are always available via tool access. Read the relevant files when a task involves deployment, server access, or infrastructure.

## Rules and Standards

### Development
- All development projects, including websites, should be committed to a private GitHub repo and pulled from there for deployment on a remote server. Never deploy by pushing files directly — always: commit → push to GitHub → pull on server.

## Updating This File

When asked to remember a rule or standard, classify it first:
- **Applies to all projects** (workflow, deployment, coding conventions, infrastructure) → update this file (`~/.claude/CLAUDE.md`)
- **Applies only to the current project** → update the project's `CLAUDE.md`

State the rule naturally. Do not ask which file — make the call based on scope.

## Auto Dream

If the file `~/.claude/.dream-pending` exists at session start, run `/dream` as a subagent in the background, then delete the flag file: `rm ~/.claude/.dream-pending`. This is the memory consolidation system - it runs automatically every 24 hours.

## What Not to Read

Do not read or scan `~/.claude/projects/` (session history), `~/.claude/settings.json`, or `~/.claude/statsig/`. These are Claude Code internals, not project context.

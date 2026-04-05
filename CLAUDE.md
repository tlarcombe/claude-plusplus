# claude++ — developer notes

## What this is

`claude++` is a bash launcher for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).
It wraps the `claude` CLI with an fzf-based project picker and shared context management.

## Files

| File | Purpose |
|------|---------|
| `claude++` | Main launcher script |
| `claude++-project-preview` | fzf preview pane — project info |
| `claude++-session-preview` | fzf preview pane — session conversation |
| `install.sh` | Installer (copies scripts, sets up symlinks) |
| `global-CLAUDE.md` | Global Claude context — loaded in every session |
| `context/` | Shared reference data (`hosts/`, `inventory/`, `patterns/`) |

## Architecture

- **Launcher** (`launch_claude`): wraps `claude --permission-mode bypassPermissions` with `--add-dir ~/.claude` so Claude can read/write `~/.claude/CLAUDE.md` and `~/.claude/context/` from any project. Passes `--name <project>` so the terminal title reflects the active project.
- **Project list** (`build_project_list`): Python inline script scanning `~/.claude/projects/` session data + `~/projects/` directories
- **Preview scripts**: called by fzf `--preview`, separate executables so fzf can invoke them directly
- **Shared context**: `global-CLAUDE.md` and `context/` live in this repo and are symlinked into `~/.claude/` by `install.sh` — on a NAS-mounted `~/projects/` this makes them available across all machines automatically

## Enriched environment (`~/.claude/`)

The following components live in `~/.claude/` and are available in every session launched via claude++:

| Component | Count | Location |
|-----------|-------|----------|
| Language rules | 16 dirs | `~/.claude/rules/` |
| Agents | 38 | `~/.claude/agents/` |
| Slash commands | 74 | `~/.claude/commands/` |
| Skills | 85 | `~/.claude/skills/` |
| Hook scripts | 35 JS/shell | `~/.claude/scripts/hooks/` |

### Active hooks (`~/.claude/settings.json`)

| Event | Hooks |
|-------|-------|
| PreToolUse | block-no-verify, commit-quality, git-push-reminder, doc-file-warning, suggest-compact, config-protection, continuous-learning |
| PostToolUse | command-log-audit, pr-created, quality-gate, console-warn, edit-accumulator |
| Stop | session-end, cost-tracker, evaluate-session, format-typecheck, check-console-log |
| SessionStart | bootstrap (loads previous context, detects package manager) |
| PreCompact | save state before compaction |

Opt-in hooks (dormant until env vars set):
- `ECC_GOVERNANCE_CAPTURE=1` — audit capture
- `ECC_ENABLE_INSAITS=1` — AI security scanning

### Shell environment

`CLAUDE_PLUGIN_ROOT=$HOME/.claude` is set in `~/.zshrc` so hook scripts resolve correctly.

## Session directory encoding

Claude Code encodes project paths by replacing every non-alphanumeric character with `-`.
The `encode_path` function must stay in sync with that behaviour — it's used for finding
and migrating session JSONL files when renaming projects.

## Keybindings (fzf picker)

| Key | Action |
|-----|--------|
| Enter | Open project |
| Ctrl-Y | Session history browser |
| Ctrl-F | Search within project sessions |
| Ctrl-S | Search all sessions |
| Ctrl-R | Rename project |
| Ctrl-X | Delete project |
| Ctrl-/ | Toggle preview pane |
| Esc | Quit |

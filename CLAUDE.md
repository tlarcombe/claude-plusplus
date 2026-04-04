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

- **Launcher** (`launch_claude`): wraps `claude --permission-mode bypassPermissions` with `--add-dir ~/.claude` so Claude can read/write `~/.claude/CLAUDE.md` and `~/.claude/context/` from any project
- **Project list** (`build_project_list`): Python inline script scanning `~/.claude/projects/` session data + `~/projects/` directories
- **Preview scripts**: called by fzf `--preview`, separate executables so fzf can invoke them directly
- **Shared context**: `global-CLAUDE.md` and `context/` live in this repo and are symlinked into `~/.claude/` by `install.sh` — on a NAS-mounted `~/projects/` this makes them available across all machines automatically

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

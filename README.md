# claude++

An fzf-based project launcher for [Claude Code](https://docs.anthropic.com/en/docs/claude-code), with shared context management across machines.

Successor to [claude+](https://github.com/tlarcombe/claude-project_chooser).

## What it does

- Scans `~/.claude/projects/` and `~/projects/` to build a project list sorted by recent activity
- Launches Claude Code with modern flags (`--permission-mode bypassPermissions`, `--name <project>`)
- Passes `~/.claude/` to every session so Claude can look up shared reference data and update global rules
- Shows live session indicators, session history, and cross-project search
- Sets the terminal window title to the active project name
- Optional tmux wrapping via `--tmux` flag — not forced

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (`claude`)
- [fzf](https://github.com/junegunn/fzf)
- python3

## Install — single machine

```bash
git clone https://github.com/tlarcombe/claude-plusplus.git ~/claude-plusplus
cd ~/claude-plusplus
bash install.sh
claude auth   # authenticate with your Claude subscription
```

## Install — multiple machines sharing a NAS-mounted ~/projects/

If `~/projects/` is a network-mounted drive available on all your machines at the same path, clone once and run the installer on each machine:

```bash
# On the first machine (or wherever ~/projects/ is writable):
git clone https://github.com/tlarcombe/claude-plusplus.git ~/projects/claude-plusplus

# On every machine (including the first):
cd ~/projects/claude-plusplus
bash install.sh
claude auth   # authenticate once per machine
```

The installer symlinks `~/.claude/CLAUDE.md` and `~/.claude/context/` to the repo. Any rules or reference data you add are instantly available on all machines with no sync step.

## Usage

```bash
claude++          # open project picker
claude++ --tmux   # same, wrapped in a named tmux session (attach/detach)
```

## Picker keybindings

| Key | Action |
|-----|--------|
| `Enter` | Open project (resumes most recent session if one exists) |
| `Ctrl-Y` | Browse session history for selected project |
| `Ctrl-F` | Search within selected project's sessions |
| `Ctrl-S` | Search across all sessions |
| `Ctrl-R` | Rename project (migrates session data) |
| `Ctrl-X` | Delete project and session data |
| `Ctrl-/` | Toggle preview pane |
| `Esc` | Quit |

## Shared context

`~/.claude/context/` is passed to every Claude session via `--add-dir`. Add Markdown files here so Claude can look them up when needed:

```
~/.claude/context/
    hosts/          # e.g. webserver.md — IP, SSH key, nginx config path
    inventory/      # e.g. web-apps.md — running services and their URLs
    patterns/       # e.g. deployment.md — conventions for your stack
```

## Global rules

`~/.claude/CLAUDE.md` is loaded automatically by Claude Code in every session. Edit it to add rules that apply across all projects — coding conventions, deployment standards, etc.

Claude will update it automatically when you state a new global rule mid-session. Project-specific rules go in the project's own `CLAUDE.md`.

## Enriched environment

claude++ is designed to work with an enriched `~/.claude/` directory. The following components are supported and loaded automatically when present:

| Component | Location | Purpose |
|-----------|----------|---------|
| Language rules | `~/.claude/rules/` | Coding standards per language/framework |
| Agents | `~/.claude/agents/` | Specialist subagents (reviewer, planner, etc.) |
| Slash commands | `~/.claude/commands/` | Custom `/commands` available in every session |
| Skills | `~/.claude/skills/` | Deep reference material for specific tasks |
| Hook scripts | `~/.claude/scripts/hooks/` | Automated behaviours (quality gates, session tracking, etc.) |

Hooks are wired via `~/.claude/settings.json`. When present, the bootstrap hook loads previous session context and detects the project's package manager on session start.

## What's different from claude+

| claude+ | claude++ |
|---------|----------|
| Forces tmux on every launch | No tmux unless you pass `--tmux` |
| `--dangerously-skip-permissions` | `--permission-mode bypassPermissions` |
| Rate-limit auto-retry (fragile) | Dropped — just return to picker |
| Merge / archive / fork | Dropped |
| No shared context | `--add-dir ~/.claude` on every launch |
| No window title management | Terminal title set to project name via `--name` |
| 1501 lines | ~480 lines |

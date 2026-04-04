# claude++

A next-generation harness wrapper for Claude Code, building on and superseding `claude+`.

## Project Goals

1. **Sanity-check `claude+`** — audit the existing project chooser at `~/projects/claude-project_chooser/` for bugs, fragility, and obsolete patterns
2. **Modernise for Claude Code 2.x** — incorporate new flags and capabilities added since `claude+` was written
3. **Build `claude++`** — a cleaner, more robust harness that avoids the known limitations of `claude+`

## Source Projects

| Project | Location | Notes |
|---------|----------|-------|
| `claude+` | `~/projects/claude-project_chooser/claude+` | Original 1501-line bash launcher |
| Preview scripts | `~/projects/claude-project_chooser/claude-project-preview` | fzf preview pane helper |
| Session preview | `~/projects/claude-project_chooser/claude-session-preview` | Session JSONL preview |
| `clive+` | `~/projects/clive+/` | Fork of claude+ using Ollama/local models |

## Known Limitations of claude+

- Uses `--dangerously-skip-permissions` unconditionally (Claude Code 2.x has `--permission-mode` with granular options: `acceptEdits`, `auto`, `bypassPermissions`, `default`, `dontAsk`, `plan`)
- Rate-limit detection via `script` capture + regex scraping of terminal output — fragile, breaks with terminal encoding changes
- Monolithic 1501-line bash script — hard to maintain and test
- No support for modern flags: `--model`, `--effort`, `--name`, `--worktree`, `--from-pr`, `--fork-session`, `--fallback-model`, `--max-budget-usd`
- Rate-limit menu auto-dismissal uses `tmux send-keys` which is tmux-only and timing-dependent
- `script -qfc` usage is Linux-specific and produces binary ANSI output that must be stripped
- Session directory encoding (`re.sub(r'[^a-zA-Z0-9]', '-', path)`) must stay in sync with Claude Code's internal encoding

## New Claude Code 2.x Capabilities (v2.1.92)

- `--permission-mode <mode>` — replaces blanket `--dangerously-skip-permissions`
- `--effort <level>` — low/medium/high/max token effort
- `--model <alias>` — supports `sonnet`, `opus`, `haiku` aliases
- `--name <name>` — display name for session (visible in `/resume`)
- `--worktree [name]` — built-in git worktree support with optional `--tmux`
- `--from-pr [value]` — resume session linked to a PR
- `--fork-session` — create new session ID when resuming
- `--resume [value]` — interactive session picker built into CC itself
- `--fallback-model <model>` — auto-fallback when primary model overloaded
- `--max-budget-usd <amount>` — cost control per session
- `--agents <json>` — inline custom agent definitions
- `--bare` — minimal mode (no hooks, plugins, CLAUDE.md discovery)
- Plugin system (`claude plugin` commands)

## Architecture Plan

`claude++` will be a modular bash script comprising:

1. **Picker** — fzf-based project/session selector (retained from `claude+`, cleaned up)
2. **Launcher** — wraps `claude` with modern flags, replaces fragile `script`-based output capture
3. **Rate-limit handler** — cleaner detection using Claude's exit codes or `--output-format=stream-json` where possible
4. **Project operations** — create, rename, archive, delete, merge, fork (retained from `claude+`)
5. **Preview scripts** — `claude++-project-preview`, `claude++-session-preview`

## Development Notes

- Install target: `~/.local/bin/claude++`
- Companion scripts: `~/.local/bin/claude++-project-preview`, `~/.local/bin/claude++-session-preview`
- Must work inside and outside tmux
- Should degrade gracefully if tmux is not available
- Python 3 inline scripts retained where needed for JSON/date parsing

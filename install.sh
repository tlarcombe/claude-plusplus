#!/bin/bash
# Install claude++ on any lab machine.
# ~/projects/ must be NAS-mounted before running this.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME/.local/bin"
CLAUDE_DIR="$HOME/.claude"

# ── Checks ────────────────────────────────────────────────────────────────────
if ! command -v claude &>/dev/null; then
    echo "ERROR: Claude Code is not installed on this machine."
    echo "       Install from: https://claude.ai/download"
    echo "       Then run: claude auth"
    exit 1
fi

if ! command -v fzf &>/dev/null; then
    echo "ERROR: fzf is required."
    echo "       Install with: sudo pacman -S fzf   (or your distro's package manager)"
    exit 1
fi

# ── Scripts ───────────────────────────────────────────────────────────────────
mkdir -p "$DEST"
for script in claude++ claude++-project-preview claude++-session-preview; do
    cp "$SCRIPT_DIR/$script" "$DEST/$script"
    chmod +x "$DEST/$script"
    echo "  Installed: $DEST/$script"
done

# ── Shared config (symlinked from NAS) ────────────────────────────────────────
mkdir -p "$CLAUDE_DIR"

# ~/.claude/CLAUDE.md → shared global rules on NAS
if [ -L "$CLAUDE_DIR/CLAUDE.md" ]; then
    echo "  Symlink exists: $CLAUDE_DIR/CLAUDE.md (skipping)"
elif [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    echo "  WARNING: $CLAUDE_DIR/CLAUDE.md exists as a regular file."
    echo "  Back it up and re-run, or merge it into $SCRIPT_DIR/global-CLAUDE.md manually."
    echo "  Skipping CLAUDE.md symlink."
else
    ln -s "$SCRIPT_DIR/global-CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
    echo "  Linked:    $CLAUDE_DIR/CLAUDE.md → $SCRIPT_DIR/global-CLAUDE.md"
fi

# ~/.claude/context/ → shared reference data on NAS
if [ -L "$CLAUDE_DIR/context" ]; then
    echo "  Symlink exists: $CLAUDE_DIR/context (skipping)"
elif [ -d "$CLAUDE_DIR/context" ]; then
    echo "  WARNING: $CLAUDE_DIR/context exists as a real directory."
    echo "  Migrate any content into $SCRIPT_DIR/context/ then remove it and re-run."
    echo "  Skipping context symlink."
else
    ln -s "$SCRIPT_DIR/context" "$CLAUDE_DIR/context"
    echo "  Linked:    $CLAUDE_DIR/context → $SCRIPT_DIR/context"
fi

# ── Done ─────────────────────────────────────────────────────────────────────
echo ""
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo "  NOTE: $HOME/.local/bin is not in your PATH."
    echo "        Add to ~/.bashrc or ~/.zshrc:  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
fi
echo "  Done. Run: claude++"

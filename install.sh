#!/bin/bash
# Install claude++ scripts to ~/.local/bin/
set -euo pipefail

DEST="$HOME/.local/bin"
mkdir -p "$DEST"

for script in claude++ claude++-project-preview claude++-session-preview; do
    cp "$script" "$DEST/$script"
    chmod +x "$DEST/$script"
    echo "Installed: $DEST/$script"
done

mkdir -p "$HOME/.claude/context/"{hosts,inventory,patterns}
echo "Context directories ready: ~/.claude/context/"

echo ""
echo "Done. Run: claude++"

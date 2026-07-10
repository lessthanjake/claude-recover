#!/bin/sh
# Install claude-recover: the CLI to ~/.local/bin, the skill to ~/.claude/skills.
set -eu

cd "$(dirname "$0")"

mkdir -p "$HOME/.local/bin"
cp bin/claude-recover "$HOME/.local/bin/claude-recover"
chmod +x "$HOME/.local/bin/claude-recover"
echo "installed CLI      -> $HOME/.local/bin/claude-recover"

mkdir -p "$HOME/.claude/skills/recover-sessions"
cp skills/recover-sessions/SKILL.md "$HOME/.claude/skills/recover-sessions/SKILL.md"
echo "installed skill    -> $HOME/.claude/skills/recover-sessions/ (use /recover-sessions in Claude Code)"

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) echo "note: $HOME/.local/bin is not on your PATH — add it to your shell profile" ;;
esac

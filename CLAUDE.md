# claude-recover — agent notes

CLI + Claude Code skill that lists recent Claude Code sessions after a crash and
reopens the top N in new terminal windows via `claude --resume`.

## Layout

- `bin/claude-recover` — the entire tool: a single Python 3 script, stdlib only.
  No dependencies, no build step.
- `skills/recover-sessions/SKILL.md` — Claude Code skill wrapping the CLI
  (installed to `~/.claude/skills/recover-sessions/`).
- `install.sh` — copies the two pieces into place.

## Constraints

- **No personal data.** This is a public repo. Never hardcode usernames, home
  paths, real project names, or session IDs (README examples use placeholders).
  Derive paths from `Path.home()` and environment variables only.
- **Stdlib only.** The script must run on stock macOS `python3` with no pip installs.
- **Transcripts are read-only.** Never write to, move, or delete anything under
  `~/.claude/projects`.
- Working directories must come from the transcript's `cwd` field — decoding the
  encoded folder name is ambiguous (`/` and `_` both become `-`).

## Testing

No test suite. Sanity-check changes with:

```bash
python3 bin/claude-recover            # list mode — safe, read-only
python3 bin/claude-recover --days 1   # narrower window
```

Only pass a count (e.g. `claude-recover 2`) if you actually intend to open
terminal windows on the user's machine.

## Syncing

The installed copies at `~/.local/bin/claude-recover` and
`~/.claude/skills/recover-sessions/` do not update themselves — after changing
the repo, rerun `./install.sh`.

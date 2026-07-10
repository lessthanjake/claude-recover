# claude-recover

Your machine crashed with five Claude Code sessions open. Which projects were they
in? What was each one doing? `claude-recover` answers that and reopens them — one
terminal window per session, each `cd`'d into the right folder and resumed with its
full history intact.

```
$ claude-recover
 1. Jul 09 05:05 PM  ~/code/my-project
    Let's continue the database migration — the schema changes are approved…
    id: 1f0c9e2a-7b3d-4e5f-8a91-2c4d6e8f0a1b
 2. Jul 09 04:28 PM  ~/infra
    Can I get your help totaling storage usage across these buckets…
    id: 9d7b5f3e-1a2c-4b6d-8e0f-3a5c7e9b1d2f
 ...

$ claude-recover 2      # reopen the top two in new terminal windows
```

## How it works

Claude Code writes every session transcript to `~/.claude/projects/<encoded-path>/<session-id>.jsonl`.
`claude-recover` scans those transcripts and shows the most recent sessions with:

- when the session was last active
- its working directory — read from the transcript's own `cwd` field, not decoded
  from the folder name (the encoding turns both `/` and `_` into `-`, so decoding
  is ambiguous)
- the first real user message, so you can tell sessions apart at a glance

Given a count, it reopens the top N sessions, each in a new window of your terminal
(iTerm2 if present, otherwise Terminal.app) running `claude --resume <session-id>`
from the correct directory. Sessions whose working folder no longer exists are
skipped with a warning.

## Requirements

- macOS (window-opening uses AppleScript; the listing works anywhere)
- Python 3 (system Python is fine — no dependencies)
- [Claude Code](https://claude.com/claude-code)
- iTerm2 or Terminal.app

## Install

```bash
git clone https://github.com/lessthanjake/claude-recover.git
cd claude-recover
./install.sh
```

This copies:

- `bin/claude-recover` → `~/.local/bin/claude-recover` (make sure `~/.local/bin` is on your `PATH`)
- `skills/recover-sessions/` → `~/.claude/skills/recover-sessions/` — an optional
  Claude Code skill so you can type `/recover-sessions` inside any Claude session
  and have Claude run the recovery for you (it excludes the session you're typing in)

Or install by hand: copy `bin/claude-recover` anywhere on your `PATH` and
`chmod +x` it; copy the `skills/recover-sessions` folder into `~/.claude/skills/`
if you want the slash command.

## Usage

```bash
claude-recover                # list the 10 most recent sessions (last 7 days)
claude-recover 3              # list, then reopen the top 3
claude-recover --days 2       # only look at the last 2 days
claude-recover --max 20       # list up to 20 sessions
claude-recover --exclude ID   # skip a session (id prefix ok, repeatable),
                              #   e.g. the one you're currently sitting in
```

Inside Claude Code (with the skill installed):

```
/recover-sessions
```

## Uninstall

```bash
rm ~/.local/bin/claude-recover
rm -rf ~/.claude/skills/recover-sessions
```

## Notes

- Read-only with respect to Claude's data: it never modifies or deletes transcripts.
- Reopening uses `claude --resume`, so each session comes back exactly where it
  left off — transcripts survive crashes; this tool just saves you the archaeology.

## License

MIT

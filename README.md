# claude-recover

Your machine crashed with five Claude Code sessions open. Which projects were they
in? What was each one doing? `claude-recover` answers that and reopens them — one
iTerm2 window with a tab per session, each `cd`'d into the right folder and resumed
with its full history intact.

```
$ claude-recover --auto     # reopen everything from the last burst of activity
 1. Mar 14 02:10 PM  ~/code/webapp
    the login form throws a 500 when the email has a plus sign in it, can you take a look…
    id: 1f0c9e2a-7b3d-4e5f-8a91-2c4d6e8f0a1b
 2. Mar 14 11:42 AM  ~/notes
    turn these meeting notes into a checklist sorted by owner…
    id: 9d7b5f3e-1a2c-4b6d-8e0f-3a5c7e9b1d2f
 ...

$ claude-recover 2      # or: reopen exactly the top two
```

## How it works

Claude Code writes every session transcript to `~/.claude/projects/<encoded-path>/<session-id>.jsonl`.
`claude-recover` scans those transcripts and shows the most recent sessions with:

- when the session was last active
- its working directory — read from the transcript's own `cwd` field, not decoded
  from the folder name (the encoding turns both `/` and `_` into `-`, so decoding
  is ambiguous)
- the first real user message, so you can tell sessions apart at a glance

Reopening runs `claude --resume <session-id>` from the correct directory, as tabs in
one new iTerm2 window (Terminal.app has no scriptable tabs, so it gets one window
per session; `--windows` forces that layout in iTerm2 too). Sessions whose working
folder no longer exists are skipped with a warning.

### `--auto`: deterministic crash recovery

`--auto` picks the sessions for you, with no judgement calls, so it's safe to run
from a shell alias or a fresh terminal right after a crash:

1. Take the most recent session and walk backwards in time while the silence
   between consecutive sessions is under `--gap` minutes (default 120). That burst
   is what was active when things died.
2. Drop anything already running (it checks `ps` for `claude --resume <id>` and for
   bare `claude` processes by working directory), the session you're typing in
   (`CLAUDE_CODE_SESSION_ID`), anything passed with `--exclude`, and sessions whose
   folder is gone.
3. Reopen the rest. `-n` / `--dry-run` shows the plan without opening anything.

Running it twice is harmless: the second run finds everything already running and
opens nothing. If the crash was long enough ago that a newer session has started
since, the burst may contain only that newer session; widen `--gap` or fall back
to an explicit count.

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
  and have Claude run `claude-recover --auto` for you

Or install by hand: copy `bin/claude-recover` anywhere on your `PATH` and
`chmod +x` it; copy the `skills/recover-sessions` folder into `~/.claude/skills/`
if you want the slash command.

## Usage

```bash
claude-recover                # list the 10 most recent sessions (last 7 days)
claude-recover --auto         # reopen the last burst of activity (see above)
claude-recover --auto -n      # ...but only show what would be opened
claude-recover --gap 30 --auto  # a 30-minute silence ends the burst
claude-recover 3              # list, then reopen the top 3
claude-recover --windows 3    # one window per session instead of tabs
claude-recover --days 2       # only look at the last 2 days
claude-recover --max 20       # list up to 20 sessions
claude-recover --exclude ID   # skip a session (id prefix ok, repeatable);
                              #   the current session and running ones are
                              #   skipped automatically
claude-recover --crazy 3      # reopen with --dangerously-skip-permissions
                              #   (skips ALL permission prompts — only for
                              #   sessions/folders you fully trust)
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

---
name: recover-sessions
description: After a crash or accidental terminal close, reopen the Claude Code sessions that were active, each resumed in its correct working folder as a tab in one iTerm2 window. Use when the user says their computer/terminal crashed and they want their sessions back.
---

Recover recent Claude Code sessions using the `claude-recover` CLI (installed at
`~/.local/bin/claude-recover`). The CLI is deterministic and does the whole job
itself; your role is to run it and relay the result.

## Steps

1. Preview what it would do:

   ```bash
   claude-recover --auto -n
   ```

   `--auto` finds the most recent burst of activity (sessions with no silence longer
   than 120 minutes between them, tunable with `--gap MIN`) and selects every session
   in it that is not already running, is not the current session (it reads
   `CLAUDE_CODE_SESSION_ID`), and whose working folder still exists.

2. If the preview matches what the user described, reopen them:

   ```bash
   claude-recover --auto
   ```

   Sessions open as tabs in one new iTerm2 window (Terminal.app falls back to one
   window each). Pass `--windows` if the user wants separate windows.

3. If `--auto` reports "nothing to reopen" (e.g. the crash was hours ago and a
   newer session has since been started), show the plain list and let the user
   pick a count:

   ```bash
   claude-recover              # list
   claude-recover N            # reopen the top N (still skips running/current)
   ```

   For a non-contiguous selection, `--exclude ID` (prefix ok, repeatable) removes
   entries before counting.

4. Report which sessions were reopened and which were skipped (already running,
   folder missing). The CLI prints both.

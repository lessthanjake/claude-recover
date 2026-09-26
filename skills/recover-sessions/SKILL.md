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

   `--auto` first sets aside sessions that are already running, the current session
   (it reads `CLAUDE_CODE_SESSION_ID`), and headless `claude -p` / SDK runs. From the
   rest it takes the most recent burst of activity (no silence longer than 120
   minutes between sessions, tunable with `--gap MIN`) and selects every session in
   it whose working folder still exists. Post-crash activity therefore doesn't hide
   the crash burst.

2. If the preview matches what the user described, reopen them:

   ```bash
   claude-recover --auto
   ```

   Sessions open as tabs in one new iTerm2 window (Terminal.app falls back to one
   window each). Pass `--windows` if the user wants separate windows.

3. If `--auto` picks the wrong burst (e.g. the user closed some sessions cleanly
   after the crash), show the plain list and let the user pick a count:

   ```bash
   claude-recover              # list
   claude-recover N            # reopen the top N (still skips running/current)
   ```

   For a non-contiguous selection, `--exclude ID` (prefix ok, repeatable) removes
   entries before counting.

4. Report which sessions were reopened and which were skipped (already running,
   folder missing). The CLI prints both.

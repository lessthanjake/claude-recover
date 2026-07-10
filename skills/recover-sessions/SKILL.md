---
name: recover-sessions
description: After a crash or accidental terminal close, list recent Claude Code sessions and reopen the top N in new terminal windows, each resumed in its correct working folder. Use when the user says their computer/terminal crashed and they want their sessions back.
---

Recover recent Claude Code sessions using the `claude-recover` CLI (installed at
`~/.local/bin/claude-recover`).

## Steps

1. Determine the current session's ID so it isn't offered for reopening — it is the
   UUID in this session's scratchpad directory path.

2. List recent sessions:

   ```bash
   claude-recover --exclude <current-session-id>
   ```

   Useful flags: `--days N` to narrow the window (default 7), `--max N` for list length.

3. Show the user the list (last active, working folder, what the session was about).
   If the user already said how many to reopen (e.g. "the top three"), skip the ask.
   Otherwise ask which ones they want reopened.

4. Reopen the top N (opens one new terminal window per session — iTerm2 if present,
   otherwise Terminal.app — cd'd into the right folder, running `claude --resume <id>`):

   ```bash
   claude-recover --exclude <current-session-id> N
   ```

   To reopen a non-contiguous selection (e.g. #2 and #4 only), run a resume command
   per session in a new terminal window instead:

   ```bash
   osascript -e 'tell application "iTerm"
     activate
     tell current session of (create window with default profile) to write text "cd <folder> && claude --resume <session-id>"
   end tell'
   ```

5. Report which sessions were reopened. If a session's working folder no longer
   exists, the script skips it and says so — surface that to the user.

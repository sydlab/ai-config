# Open editors

When the user asks to open, navigate to, or work in a project folder:

- Open the folder in **IntelliJ IDEA CE**: `env -u NO_COLOR -u FORCE_COLOR -u TERM -u TERM_PROGRAM -u TERM_PROGRAM_VERSION -u TERM_SESSION_ID open -a "IntelliJ IDEA CE" -- <path>`. The agent shell's color-disabling variables otherwise leak into IntelliJ and turn off colors in its terminal.
- Open the same path in **Cursor CLI agent** in a new **iTerm2** tab. Never use macOS Terminal.app.

```applescript
tell application "iTerm"
  activate
  tell current window
    create tab with default profile
    tell current session
      write text "cd <path> && exec agent --workspace <path> --trust"
    end tell
  end tell
end tell
```

If no iTerm window exists, create one first, then run the same `cd` + `agent --workspace` command.

- Do **not** use the Cursor IDE (`cursor`, `cursor -n`, `cursor -r`) unless they explicitly ask for it

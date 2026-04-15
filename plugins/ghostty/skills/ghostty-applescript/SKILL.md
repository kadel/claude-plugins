---
name: ghostty
description: This skill should be used when the user asks to "open a split", "show markdown", "preview markdown", "render markdown in ghostty", "open ghostty split", "show file in split", or wants to control Ghostty terminal via AppleScript commands.
version: 0.1.0
---

## Purpose

Control the Ghostty terminal emulator via AppleScript. Provides commands to manipulate splits, send input, and display content in new terminal panes.

## Prerequisites

- **Ghostty** terminal emulator must be running on macOS
- **glow** CLI must be installed for markdown rendering (`brew install glow`)

## Commands

### render-markdown-split

Open a right split in the current Ghostty window and render a markdown file using `glow`.

#### Arguments

- `file` (required): Path to the markdown file to render

#### Workflow

1. Resolve the markdown file path to an absolute path
2. Verify the file exists and has a `.md` extension
3. Run the following AppleScript via `osascript` to create a split and render the file:

```bash
osascript -e "
tell application \"Ghostty\"
    set w to front window
    set t to focused terminal of selected tab of w
    set t2 to split t direction right
    delay 0.5
    input text \"glow -p ${ABSOLUTE_FILE_PATH}\" & return to t2
end tell
"
```

#### Important Notes

- The `delay 0.5` is necessary to allow the new split to initialize before sending input
- Always use absolute paths for the file to avoid working directory issues in the new split
- The `-p` flag enables pager mode in glow for scrollable output
- If `glow` is not installed, inform the user and suggest `brew install glow`

#### Error Handling

- If the file does not exist, report the error to the user — do not run the AppleScript
- If `osascript` returns an error about `focused terminal`, Ghostty may not be the active application — advise the user to focus Ghostty first

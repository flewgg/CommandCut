# Command X

Command X is a tiny menubar app for macOS that enables **Cut (Cmd+X)** and **Paste (Cmd+V)** in Finder, similar to Windows/Linux.

This was inspired by [Command X](https://sindresorhus.com/command-x). I built this because I didn’t want to pay $4 for a very simple shortcut remap.

## How It Works
- When Finder is frontmost:
  - `Cmd+X` triggers a copy
  - The next `Cmd+V` becomes **Move** (Finder’s `Cmd+Option+V`)
- Normal `Cmd+C` and `Cmd+V` still behave as expected.

## Permissions
- **Input Monitoring** is required to capture keyboard shortcuts.

## Install
- Download the latest DMG from Releases.
- Drag the app into Applications.
- Run it once and grant Input Monitoring access.

## Security
- App Sandbox enabled
- No network access
- No file access outside its sandbox

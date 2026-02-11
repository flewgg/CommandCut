# Shear

Shear is a tiny menubar app for macOS that enables **Cut (⌘X)** and **Paste (⌘V)** in Finder, similar to Windows/Linux.

## How It Works
- When Finder is frontmost:
  - Your selected modifier shortcut + `X` triggers a copy
  - The next `⌘V` becomes **Move** (`⌘⌥V`)
- Modifier options in Settings: `⌃` (Control), `⌘` (Command), and `Fn/Globe`.
- `⌘` mode may interfere with Finder text cut in editing fields.
- Normal `⌘C` and `⌘V` still behave as expected.

## Permissions
- **Input Monitoring** is required so the app can detect your shortcut while Finder is active.
- **Accessibility** is required so the app can send Finder's move-paste shortcut.

## Security

The app is sandboxed and does not request file access entitlements.

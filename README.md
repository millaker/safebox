# Safebox
Sandbox for AI agents on macOS (using Seatbelt / `sandbox-exec`) and Linux (using Bubblewrap / `bwrap`). Only avoids devastating operations like deleting system files or files outside of current project.

## Permissions
- Allow writes:
  - Current directory
  - `/tmp`
  - Agent working dirs (e.g. `~/.codex`, `~/.gemini`, `~/.claude`)
  - `/dev/null`, `/dev/zero`, `/dev/tty`
- Allow all reads except `~/.ssh`
- Deny privilege escalating commands (e.g. `sudo`, `su`, `login`, `doas`, `pkexec`)

## Prerequisites
- **macOS**: Built-in `sandbox-exec` (Seatbelt).
- **Linux**: Bubblewrap (`bwrap`) is required.
  - Debian/Ubuntu: `sudo apt install bubblewrap`
  - Fedora: `sudo dnf install bubblewrap`
  - Arch Linux: `sudo pacman -S bubblewrap`

## Installation

Run the installation script to add `safebox` to your shell's PATH:

```bash
./install.sh
```

To uninstall:

```bash
./install.sh --uninstall
```
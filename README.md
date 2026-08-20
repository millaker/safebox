# Safebox
Sandbox for AI agents on macos using seatbelt (sandbox-exec). Only avoids devastating operations like deleting system files or files outside of current project.

## Permissions
- Allow writes:
  - Current directory
  - `/tmp`
  - Agent working dirs (e.g. `.gemini`, `.claude`)
  - `/dev/null`
- Allow all reads except `~/.ssh`
- Deny privilege escalating commands, e.g. `sudo`

## Installation

Run the installation script to add `safebox` to your shell's PATH:

```bash
./install.sh
```

To uninstall:

```bash
./install.sh --uninstall
```
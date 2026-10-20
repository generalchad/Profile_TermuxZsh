# AGENTS.md

Zsh profile (oh-my-zsh, agnoster) being ported from Debian to **Android / Termux**. Dev happens on Windows; the target is Termux. Never assume a Debian host.

Docs: `docs/CONTEXT.md` (layout, status), `docs/ENGINEERING.md` (rules, commands), `docs/ROADMAP.md` (plan), `docs/TASKS.md` (open work). Read them before changing anything. This file is the short version.

## Layout

- `.zshrc` — the profile. Sections: env/PATH, oh-my-zsh, aliases (system, navigation, network, SMTP), micro functions, zellij autostart.
- `bin/` — helper scripts, deployed to `~/bin`: `checksmtp.sh`, `extract.sh`, `formatusb.sh`, `whatsmyip.sh`.
- `setup-termux.sh` — bootstrap: installs packages, oh-my-zsh, sets zsh as login shell. Run inside Termux only.

## Termux rules

- Package manager is `pkg` (or `apt`). No `sudo`, no root. Never emit `sudo`; Termux has none.
- Prefix is `$PREFIX` (`/data/data/com.termux/files/usr`). `/bin`, `/usr/bin`, `/usr/local`, `/snap`, `/etc/apache2`, `/var/www` do not exist. Use `$PREFIX/...` or `$HOME/...`.
- Hardcoded shebangs (`#!/bin/bash`) fail. Use `#!/usr/bin/env bash`, or run `termux-fix-shebang`.
- `systemd` is absent: no `resolvectl`, no `systemctl`.
- Android restricts `ip`, `ifconfig`, `ping` to varying degrees by OS version. Scripts must degrade gracefully.
- No block-device access (`lsblk`, `parted`, `mkfs.vfat`, `wipefs`) without root. `formatusb.sh` and its aliases don't belong in the port.
- No GUI/VS Code. Editor falls back to `nvim` → `vi`.
- Shared storage requires `termux-setup-storage` (creates `~/storage/...`). Don't assume `~/Desktop`, `~/Documents`, `~/Downloads`.
- `nvm` is unsupported/fragile on Termux; use the `nodejs` pkg.

## Porting status

`.zshrc` is ported (untested on-device). `bin/` is not: `checksmtp.sh`, `extract.sh`, `whatsmyip.sh` need Termux checks; `formatusb.sh` is to be deleted. See `docs/TASKS.md`.

## Conventions

- Shell scripts: `bash`, `set -euo pipefail`, quote everything, `command -v` for dependency checks, errors to stderr. Must pass `shellcheck` and `bash -n`.
- Scripts must be idempotent. Re-running is safe; back up before overwriting user files (`*.bak.<timestamp>`).
- Guard optional tools in `.zshrc` with `command -v`. A missing tool must never print errors at shell startup.
- Keep startup fast. Minimal oh-my-zsh plugins.
- Keep the `.zshrc` sectioned header style. Comment the *why*, not the what.
- Don't add features, aliases, or abstractions that weren't asked for.

## Verification

Cannot run Termux from Windows. Verify with `bash -n <script>` and `shellcheck` where available. Say plainly when something is untested on-device.

## Git

Branch `main`. Commit every change as you make it (one logical change per commit, style in `docs/ENGINEERING.md`). Never push; the user pushes unless they say otherwise.

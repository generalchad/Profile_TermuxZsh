# CONTEXT

What this repo is and how it's laid out. Rules: `ENGINEERING.md`. Plan: `ROADMAP.md`. Open work: `TASKS.md`.

## What it is

A zsh profile (oh-my-zsh, agnoster) ported from Debian to Android/Termux. Goals: one-command bootstrap, fast startup, no root, no errors on a missing tool. Non-goals: desktop/GUI features, root-only tooling, supporting non-Termux hosts.

## Layout

| Path | Role |
|------|------|
| `setup-termux.sh` | Bootstrap: packages, oh-my-zsh, default shell. `--deploy` installs `.zshrc` + `bin/`. Idempotent. |
| `.zshrc` | The profile. Sections: env/PATH, oh-my-zsh, system aliases, navigation, network/SMTP aliases, micro functions, zellij autostart. |
| `bin/checksmtp.sh` | SMTP port checker (nc, openssl, jq, timeout). |
| `bin/extract.sh` | Archive extractor. |
| `bin/whatsmyip.sh` | Local + public IPs. Uses `ip` and `grep -P`. |
| `bin/formatusb.sh` | USB formatter. Needs root and block devices; not portable to Termux. |

## Status

- `setup-termux.sh`: written, syntax-checked, **untested on a device**.
- `.zshrc`: Debian-isms removed (PATH, editor, nvm, sudo/tailscale plugins, formatusb, flushdns, bookmarks); `pinggw` is now a function. Untested on-device.
- `bin/`: still the Debian originals, not yet ported.

## Decisions

Bookmarks dropped (no `termux-setup-storage` dependency). Tailscale and sudo plugins dropped. Zellij autostart kept (guarded). All SMTP `cs*` aliases kept.

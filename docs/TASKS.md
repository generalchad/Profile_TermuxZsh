# TASKS

Open work only. One task per commit; delete a task when it's done. If the code doesn't match a task, stop and ask.

## Needs a device
- [ ] **V1.** Run `setup-termux.sh` on a fresh Termux; confirm package names (`dnsutils`, `netcat-openbsd`, `7zip`, `zellij`, `openssl-tool`) via `pkg search`; fix any that fail.
- [ ] **V2.** Re-run the script; confirm it's idempotent and `--deploy` backs up existing files.

## M1. `.zshrc`
- [ ] **Z9.** On-device: new shell prints nothing; `pinggw`, `topcpu`, `ps` alias work (or fail cleanly). `ps auxf` may not work with Android's ps; needs `procps`.
- [ ] **Z10.** Check `checksmtp` alias still points at a script that runs (B1).

## M2. `bin/`
- [ ] **B1.** `checksmtp.sh`: `#!/usr/bin/env bash`; verify `nc`, `openssl`, `jq`, `timeout` work on Termux.
- [ ] **B2.** `whatsmyip.sh`: no `grep -P` dependency; fall back when `ip` is restricted.
- [ ] **B3.** Delete `bin/formatusb.sh`.
- [ ] **B4.** `extract.sh`: drop `unrar` branch (no Termux package) or make it report that.

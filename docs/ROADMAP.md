# ROADMAP

Milestones in order. Each is done when its exit line is true on a real device.

## M0. Bootstrap — written, untested on-device
`setup-termux.sh` installs zsh, tools, oh-my-zsh and sets the login shell.
**Exit:** fresh Termux → run script → `zsh` starts with no errors.

## M1. Port `.zshrc` — done, untested on-device
Remove or replace the Debian-isms listed in `CONTEXT.md`. Guard optional tools. Fix `pinggw`.
**Exit:** `zsh -n` clean; new shell prints nothing; every remaining alias works or is absent.

## M2. Port `bin/` — done, untested on-device
- `extract.sh`, `checksmtp.sh`: fix shebang, verify deps exist as Termux packages.
- `whatsmyip.sh`: degrade when `ip`/`grep -P` are unavailable.
- `formatusb.sh`: dropped (D3).
**Exit:** each remaining script runs on-device.

## M3. Termux niceties (only if wanted)
`termux-setup-storage` bookmarks (`~/storage/...`), `termux-clipboard`/`termux-open` helpers, `~/.termux` font/colors. Decide per item; none are committed to. Tasks F1–F6 in `docs/TASKS.md`.

## Decisions
- **D1.** Deployment is opt-in (`--deploy`) so a bare run never replaces a user's profile.
- **D2.** Node comes from the `nodejs` pkg, not nvm.
- **D3.** `formatusb` is dropped, not ported.

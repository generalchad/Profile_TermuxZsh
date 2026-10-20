# ENGINEERING

Rules for every change.

## Commands

| Task | Command |
|------|---------|
| Syntax check | `bash -n <script>` |
| Lint | `shellcheck <script>` (if installed) |
| zsh syntax | `zsh -n .zshrc` (on Termux) |
| Bootstrap | `./setup-termux.sh [--deploy]` (Termux only) |

Can't run Termux from Windows. Say plainly what is untested on-device.

## Rules

1. **Termux first.** No `sudo`, no root, no systemd, no `/bin`, `/usr`, `/etc`, `/var`. Use `$PREFIX` and `$HOME`. Package manager is `pkg`.
2. **Shebang:** `#!/usr/bin/env bash`.
3. **Scripts:** `set -euo pipefail`, quote everything, errors to stderr, `command -v` for dependency checks, must pass `bash -n` and shellcheck.
4. **Idempotent.** Re-running is safe. Back up before overwriting (`*.bak.<timestamp>`).
5. **Quiet startup.** Guard every optional tool in `.zshrc` with `command -v`. Nothing prints at shell start. Keep it fast; few plugins.
6. **No scope creep.** Don't add aliases, features, or abstractions that weren't asked for. Delete dead code (e.g. Debian-only aliases) instead of commenting it out.
7. **Comments say why**, not what. Keep the sectioned header style in `.zshrc`.
8. **Never break the user.** Don't overwrite their `.zshrc` or `bin/` without a backup.

## Commits

Commit every change when it's done; never leave finished work uncommitted. Never push: the user pushes unless they say otherwise. Imperative, lowercase, typed prefix: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`. Body says why. One logical change per commit.

## Docs

One home per fact: layout/status in `CONTEXT.md`, rules here, plan in `ROADMAP.md`, open work in `TASKS.md`. Change the doc in the same commit as the code.

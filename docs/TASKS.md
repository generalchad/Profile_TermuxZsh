# TASKS

Open work only, written so anyone can pick one up without designing anything.

## How to work a task

1. Read `AGENTS.md` and `docs/ENGINEERING.md` once.
2. Pick a task with no **[needs decision]** tag. **[needs device]** means you need an Android phone with Termux (from F-Droid or GitHub, not the Play Store, which is outdated).
3. Follow the steps exactly. If the code doesn't match what the task says, **stop and ask**. Don't improvise.
4. Do only the task. Note anything else you spot under **Found while working** at the bottom.
5. Check your work (see "Testing" below), then commit once, using the message the task gives. End it with a blank line and your `Co-Authored-By` trailer if you use one. **Don't push**; the maintainer pushes.
6. In the same commit, delete the task from this file. If it was a check that failed, replace it with a new task describing the failure.

## Testing

| Where | How |
|-------|-----|
| Any machine with bash | `bash -n <script>` (syntax only) |
| Any machine with shellcheck | `shellcheck <script>` (no warnings) |
| Termux | `zsh -n ~/.zshrc`, then open a new session: it must print nothing |
| Termux | Run the script or alias the task names, compare with "Expected" |

Getting the repo onto a phone: in Termux run `pkg install -y git`, then `git clone <repo-url> ~/profile && cd ~/profile`. To test local changes without pushing, copy the files over with `termux-setup-storage` and `~/storage/shared/`, or SSH (task F4).

## Recipes

**Add a package to the bootstrap.** In `setup-termux.sh`, add the name to the `PACKAGES=(...)` list. Check the name exists first: `pkg search <name>` in Termux, or <https://github.com/termux/termux-packages/tree/master/packages>.

**Add an alias.** Put it in the matching section of `.zshrc`. If it calls a tool that may be missing, guard it: `command -v tool &> /dev/null && alias x='tool'`. Scripts in `bin/` are called as `$HOME/bin/name.sh`.

**Add a script.** Create `bin/name.sh` starting with `#!/usr/bin/env bash` and `set -euo pipefail`. Errors go to stderr (`>&2`) with a non-zero exit. `setup-termux.sh --deploy` copies every `bin/*.sh`, so no other wiring is needed.

---

## V. On-device checks [needs device]

Everything is written and syntax-checked on Windows but has never run on Termux. Do these first, in order, on a **fresh** Termux install (clear Termux's app data in Android settings to reset it). For each: if it passes, delete it; if it fails, replace it with a task that says what you saw (paste the error).

- [ ] **V1. Bootstrap installs.**
  1. Clone the repo (see Testing).
  2. Run `./setup-termux.sh`.
  3. Expected: ends with `[INFO] Done.` and no `Packages not installed:` warning.
  4. If a package failed: run `pkg search <name>` to find the right name, fix it in `PACKAGES`, and commit as `fix: correct Termux package name for <name>`.
  5. Close Termux completely, reopen. Expected: the prompt is zsh (`echo $0` prints `zsh` or `-zsh`).

- [ ] **V2. Bootstrap is safe to re-run.**
  1. Run `echo test > ~/.zshrc`, then `./setup-termux.sh --deploy`.
  2. Expected: a `Backed up` line; `ls ~/.zshrc.bak.*` shows one file containing `test`; `~/.zshrc` matches the repo's (`diff ~/.zshrc .zshrc` prints nothing).
  3. Run `./setup-termux.sh --deploy` again. Expected: no errors, oh-my-zsh is skipped, another backup is made.
  4. Expected: `ls ~/bin` shows `checksmtp.sh extract.sh whatsmyip.sh`, all executable (`ls -l` shows `x`).

- [ ] **V3. Shell starts clean.**
  1. Open a new Termux session.
  2. Expected: no output before the prompt, no `command not found`.
  3. Run `zsh -n ~/.zshrc`. Expected: no output.
  4. Run `pinggw`. Expected: either pings the router, or prints `pinggw: no default gateway ...` and stops. Press Ctrl+C to stop pinging.
  5. Run `topcpu` and `ps`. Expected: a process list each, no error. If `ps` complains about `f`, write it under Found while working.

- [ ] **V4. `myip`.**
  1. Run `myip` on Wi-Fi, then on mobile data.
  2. Expected: a local IP (like `192.168.x.x`) or `Unavailable (...)`; a public IPv4; IPv6 or `Unavailable`. Nothing hangs longer than about 10 seconds.
  3. Record which of `ip` and `ifconfig` worked on your Android version (run each by hand) under Found while working.

- [ ] **V5. `checksmtp`.**
  1. Run `checksmtp gmail`.
  2. Expected: `Resolving DNS... [OK] -> <an IP>`; `Tailscale not detected`; ports 587 and 465 `[OPEN]` with a `220` banner. Port 25 is often `CLOSED` on mobile networks; that's fine.
  3. Run `checksmtp nonexistent.invalid`. Expected: `[FAIL]`, no crash.
  4. Run `checksmtp` with no argument, type `exit`. Expected: it quits.

- [ ] **V6. `extract.sh`.**
  1. `cd ~ && mkdir t && cd t && echo hi > a.txt`.
  2. `zip a.zip a.txt && rm a.txt && extract.sh a.zip && cat a.txt` → `hi`.
  3. `tar czf a.tar.gz a.txt && rm a.txt && extract.sh a.tar.gz && cat a.txt` → `hi`.
  4. `7zz a a.7z a.txt` (or `7z a ...`) `&& rm a.txt && extract.sh a.7z && cat a.txt` → `hi`. Note which of `7z` / `7zz` exists under Found while working.
  5. `extract.sh nope.zip` → `'nope.zip' is not a valid file.`; `echo $?` → `1`.
  6. `cd ~ && rm -rf t`.

## H. Code health (any machine)

- [ ] **H1. Make every script pass shellcheck.**
  1. Install shellcheck: `pkg install shellcheck` (Termux), `winget install koalaman.shellcheck` (Windows), or `apt install shellcheck`.
  2. Run `shellcheck setup-termux.sh bin/*.sh`.
  3. Fix each warning the way its wiki page says (each warning has a code like `SC2086`; search `shellcheck SC2086`). Don't change behavior. If a warning is wrong for this code, add `# shellcheck disable=SCxxxx` on the line above with a short reason.
  4. Done when: the command prints nothing.
  5. Commit: `fix: clear shellcheck warnings`.

- [ ] **H2. Fix markdown lint warnings in `docs/`.**
  1. VS Code with the markdownlint extension shows them (yellow squiggles), or run `npx markdownlint-cli docs/*.md AGENTS.md`.
  2. Typical fixes: a blank line before and after every heading and list (MD022, MD032); a space inside table pipes, `| a | b |` (MD060).
  3. Text must not change, only spacing.
  4. Commit: `docs: fix markdown lint warnings`.

- [ ] **H3. Add `-u` to `checksmtp.sh`.** All scripts use `set -euo pipefail` except this one (`set -e` and `set -o pipefail`, no `-u`).
  1. Replace both `set` lines with `set -euo pipefail`.
  2. Every `"${RESULTS[$port]}"` read must survive an unset key: change it to `"${RESULTS[$port]:-}"`. Search the file for other variables read before they're set; `${var:-}` fixes each.
  3. `bash -n bin/checksmtp.sh`.
  4. **[needs device]** to finish: repeat V5. Expected: same output, no `unbound variable` error.
  5. Commit: `fix: treat unset variables as errors in checksmtp`.

## F. Features

- [ ] **F1. Install a Nerd Font.** Why: the agnoster prompt and `eza --icons` need Powerline and Nerd Font glyphs; Termux's default font shows boxes instead.
  1. In `setup-termux.sh`, add a section after `# --- oh-my-zsh ---` and before `# --- Deploy profile`, headed `# --- Font ---`.
  2. If `~/.termux/font.ttf` already exists, log `Font already present; skipping.` and do nothing (it's the user's choice).
  3. Otherwise: `mkdir -p "$HOME/.termux"`, then download with `curl -fsSL -o "$HOME/.termux/font.ttf" 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf'`. On failure, `warn` and carry on (no `die`); a missing font isn't fatal.
  4. Then run `termux-reload-settings` if `command -v` finds it.
  5. `bash -n setup-termux.sh`.
  6. **[needs device]**: run the script on a phone. Expected: the prompt shows solid arrow segments, and `ls` shows file icons. Run again: `skipping`.
  7. Update `docs/CONTEXT.md` (the `setup-termux.sh` row) and commit: `feat: install a Nerd Font in the bootstrap`.

- [ ] **F2. `extract` alias.** **[needs decision]**: maintainer decides whether `extract foo.zip` should work without `.sh`. If yes: add `alias extract='$HOME/bin/extract.sh'` in `.zshrc` under `# --- Shell Management ---`. Commit: `feat: add extract alias`.

- [ ] **F3. Extra-keys row.** **[needs decision]**: maintainer approves the key layout below. Why: a phone keyboard has no Esc, Tab, Ctrl, or arrows, which zsh and nvim need.
  1. In `setup-termux.sh`, a `# --- Keys ---` section after the font: if `~/.termux/termux.properties` has no line starting with `extra-keys`, append:

     ```properties
     extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]
     ```

     If it has one, log `extra-keys already set; skipping.` and leave it alone.
  2. Run `termux-reload-settings` if available (once, after both font and keys, is fine).
  3. **[needs device]**: two rows of keys show above the keyboard; re-running doesn't add a second line (`grep -c extra-keys ~/.termux/termux.properties` → `1`).
  4. Commit: `feat: add an extra-keys row in the bootstrap`.

- [ ] **F4. SSH into the phone.** **[needs decision]**: should `sshd` start automatically with every shell, or only by hand? Recommended: by hand. Why: testing this repo is far easier from a PC keyboard.
  1. Add `openssh` to `PACKAGES` (see Recipes).
  2. Add a short "SSH" section to `README.md` with: run `passwd` once to set a password; run `sshd` to start; `whoami` gives the user name; from the PC, `ssh -p 8022 <user>@<phone-ip>` (`myip` shows the IP). Termux's sshd uses port **8022**, not 22.
  3. **[needs device]**: connect from a PC.
  4. Commit: `feat: install openssh for remote access`.

- [ ] **F6. Clipboard helpers.** **[needs decision]**: only if the maintainer uses the Termux:API app. Idea: `myip | termux-clipboard-set` style aliases. Don't start until the maintainer names the exact aliases.

## Found while working

One line each: file, what you saw, suggested task.

- `bin/checksmtp.sh` `resolve_provider`: `proton` resolves to `127.0.0.1` ("for local testing"), so `checksmtp proton` tests the phone itself. **[needs decision]**: point it at `smtp.protonmail.ch`, or remove the alias.
- `setup-termux.sh`: `yes | pkg update ... || true` hides a failed index update; the upgrade line after it would then fail with a less clear error. Consider dropping `|| true`.
- `.zshrc` alias `p`: `p name` runs `ps aux | grep -v grep name`, so `name` is read as a file. Suggested: make `p` a function, `p() { ps aux | grep -i -- "$1" | grep -v grep; }`, and update `README.md`.

# TASKS

Open work only. One task per commit; delete a task when it's done. If the code doesn't match a task, stop and ask.

## Needs a device

Everything below is written and syntax-checked on Windows, but has never run on Termux.

- [ ] **V1.** Run `setup-termux.sh` on a fresh Termux; confirm package names (`dnsutils`, `netcat-openbsd`, `7zip`, `zellij`, `openssl-tool`, `iproute2`, `net-tools`, `procps`) via `pkg search`; fix any that fail.
- [ ] **V2.** Re-run the script; confirm it's idempotent and `--deploy` backs up existing files.
- [ ] **V3.** New shell prints nothing; `pinggw`, `topcpu`, `ps` work or fail cleanly.
- [ ] **V4.** `myip`: local IPs show (or "Unavailable"), public IPs show.
- [ ] **V5.** `checksmtp gmail`: DNS resolves via `dig`, ports report OPEN/CLOSED, Tailscale check says "not detected".
- [ ] **V6.** `extract.sh` on a `.zip`, `.tar.gz`, and `.7z` (confirms the `7zz` binary name).

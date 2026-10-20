# Termux zsh profile

A zsh setup for [Termux](https://termux.dev) on Android: oh-my-zsh with the agnoster prompt, modern `ls`/`cd` replacements, and a few network helpers. No root needed.

## Install

Install Termux from [F-Droid](https://f-droid.org/packages/com.termux/) or [GitHub](https://github.com/termux/termux-app/releases). The Play Store build is outdated. Then, in Termux:

```sh
pkg install -y git
git clone <repo-url> ~/profile
cd ~/profile
./setup-termux.sh --deploy
```

Close Termux completely and reopen it. You're in zsh.

- `./setup-termux.sh` alone installs zsh, oh-my-zsh, and the tools, and makes zsh your shell. It doesn't touch your config.
- `--deploy` also copies `.zshrc` to `~` and the scripts to `~/bin`. Anything it would overwrite is saved first as `<file>.bak.<timestamp>`.
- Safe to run again.

**Undo:** `cp ~/.zshrc.bak.<timestamp> ~/.zshrc` (use `ls ~/.zshrc.bak.*` to find it). To go back to bash: `chsh -s bash`.

**The prompt shows boxes instead of arrows?** It needs a Nerd Font. Put one at `~/.termux/font.ttf` (for example [MesloLGS NF](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf)) and run `termux-reload-settings`.

## What you get

| Command | Does |
|---------|------|
| `ls`, `ll`, `la` | List files, with icons (via `eza` when installed) |
| `z <dir>` | Jump to a directory you've visited (zoxide) |
| `..`, `...`, `....`, `bd` | Up one, two, three levels; back to the previous directory |
| `cls`, `reload-zsh`, `ep` | Clear; reload the config; edit it |
| `p`, `topcpu`, `top` | List processes; top 10 by CPU; htop |
| `myip` | Local and public IP addresses |
| `pingg`, `pinggw` | Ping Google DNS; ping your router |
| `checksmtp <host>` (`cs`) | Test SMTP ports 587, 465, 2525, 25 on a mail server. Shortcuts: `csgmail`, `cso365`, `cssendgrid`, and more in `.zshrc` |
| `extract.sh <archive>` | Unpack zip, tar, tar.gz/bz2/xz, 7z, rar |
| `cheat <cmd>` | Quick reference for a command (cheat.sh) |
| `weather [city]` | Weather forecast (wttr.in) |

[zellij](https://zellij.dev) starts automatically in each new session if it's installed.

## Notes

- Android limits what apps can see of the network, so `myip` may show "Unavailable" for local IPs and `pinggw` may not find your router. Both say so instead of failing silently.
- Port 25 is often blocked on mobile networks; `checksmtp` reporting it `CLOSED` is normal.

Contributing: start with [AGENTS.md](AGENTS.md) and [docs/TASKS.md](docs/TASKS.md).

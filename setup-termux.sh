#!/usr/bin/env bash
# Bootstrap zsh + oh-my-zsh on Termux.
# Usage: ./setup-termux.sh [--deploy]
#   --deploy  Install this repo's .zshrc and bin/ into $HOME (existing files backed up).
# Idempotent: safe to re-run.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d%H%M%S)"
DEPLOY=0

PACKAGES=(zsh git curl wget openssl-tool netcat-openbsd jq dnsutils
          unzip zip tar 7zip neovim htop eza zoxide zellij nmap nodejs
          iproute2 net-tools procps)

log()  { printf '\033[0;36m[INFO]\033[0m %s\n' "$*" >&2; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[0;31m[CRIT]\033[0m %s\n' "$*" >&2; exit 1; }

for arg in "$@"; do
    case "$arg" in
        --deploy) DEPLOY=1 ;;
        -h|--help) sed -n '2,5p' "${BASH_SOURCE[0]}"; exit 0 ;;
        *) die "Unknown argument: $arg" ;;
    esac
done

# --- Preconditions ---
[[ -n "${TERMUX_VERSION:-}" || "${PREFIX:-}" == */com.termux/* ]] \
    || die "Not running in Termux."
[[ $EUID -ne 0 ]] || die "Do not run as root."
command -v pkg >/dev/null || die "'pkg' not found."

backup() {
    local target="$1"
    if [[ -e "$target" || -L "$target" ]]; then
        mv "$target" "${target}.bak.${STAMP}"
        log "Backed up $target -> ${target}.bak.${STAMP}"
    fi
}

# --- Packages ---
log "Updating package index and upgrading..."
yes | pkg update -y -o Dpkg::Options::="--force-confold" >/dev/null || true
pkg upgrade -y -o Dpkg::Options::="--force-confold"

log "Installing packages..."
missing=()
for p in "${PACKAGES[@]}"; do
    if pkg install -y "$p" >/dev/null 2>&1; then
        log "  ok: $p"
    else
        warn "  failed: $p"
        missing+=("$p")
    fi
done
command -v zsh >/dev/null || die "zsh failed to install."

# --- oh-my-zsh ---
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    log "oh-my-zsh already present; skipping."
else
    log "Installing oh-my-zsh..."
    omz_installer="$(mktemp)"
    trap 'rm -f "$omz_installer"' EXIT
    curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
        -o "$omz_installer" || die "Could not download oh-my-zsh installer."
    # RUNZSH=no: don't drop into zsh; CHSH=no: handled below; KEEP_ZSHRC=yes: don't clobber.
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh "$omz_installer" --unattended \
        || die "oh-my-zsh install failed."
fi

# --- Deploy profile (opt-in) ---
if [[ $DEPLOY -eq 1 ]]; then
    log "Deploying profile from $REPO_DIR..."
    if [[ -f "$REPO_DIR/.zshrc" ]]; then
        backup "$HOME/.zshrc"
        cp "$REPO_DIR/.zshrc" "$HOME/.zshrc"
    else
        warn "No .zshrc in repo; skipping."
    fi
    if [[ -d "$REPO_DIR/bin" ]]; then
        mkdir -p "$HOME/bin"
        for f in "$REPO_DIR"/bin/*.sh; do
            [[ -e "$f" ]] || continue
            dest="$HOME/bin/$(basename "$f")"
            [[ -e "$dest" ]] && backup "$dest"
            cp "$f" "$dest"
            termux-fix-shebang "$dest" 2>/dev/null || true
            chmod +x "$dest"
        done
    fi
fi

# --- Default shell ---
if [[ "$(basename "${SHELL:-}")" != "zsh" ]]; then
    log "Setting zsh as default shell..."
    chsh -s zsh || warn "chsh failed; run 'chsh -s zsh' manually."
fi

# --- Summary ---
log "Done."
[[ ${#missing[@]} -eq 0 ]] || warn "Packages not installed: ${missing[*]}"
[[ $DEPLOY -eq 1 ]] || log "Profile not deployed (re-run with --deploy)."
log "Restart Termux (or run 'zsh') to enter the new shell."

#!/usr/bin/env bash
set -euo pipefail

die() { echo "extract: $*" >&2; exit 1; }

# Termux's 7zip package installs '7zz'; p7zip and Debian install '7z'.
sevenzip() {
    if command -v 7z > /dev/null; then 7z "$@"
    elif command -v 7zz > /dev/null; then 7zz "$@"
    else die "7-Zip not found (pkg install 7zip)"
    fi
}

[[ $# -eq 1 ]] || die "usage: extract <archive>"
[[ -f "$1" ]] || die "'$1' is not a valid file."

case "$1" in
    *.tar.bz2)  tar xvjf "$1" ;;
    *.tar.gz)   tar xvzf "$1" ;;
    *.tar.xz)   tar xvJf "$1" ;;
    *.tar)      tar xvf "$1" ;;
    *.zip)      unzip "$1" ;;
    # 7-Zip extracts RAR too, so unrar is optional.
    *.rar)      if command -v unrar > /dev/null; then unrar x "$1"; else sevenzip x "$1"; fi ;;
    *.7z)       sevenzip x "$1" ;;
    *)          die "Unsupported format." ;;
esac

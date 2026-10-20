#!/usr/bin/env bash
set -euo pipefail

# Android 10+ may deny netlink to apps ('ip' fails) while ioctl-based
# 'ifconfig' still works, so try both and say so if neither does.
local_ips() {
    local ips=""
    if command -v ip > /dev/null; then
        ips=$(ip -4 addr show scope global 2>/dev/null \
            | awk '/inet / {split($2, a, "/"); print a[1]}' || true)
    fi
    if [[ -z "$ips" ]] && command -v ifconfig > /dev/null; then
        ips=$(ifconfig 2>/dev/null \
            | grep -Eo 'inet (addr:)?([0-9]{1,3}\.){3}[0-9]{1,3}' \
            | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' \
            | grep -v '^127\.' || true)
    fi
    if [[ -n "$ips" ]]; then
        echo "$ips"
    else
        echo "Unavailable (ip/ifconfig blocked or missing)"
    fi
}

echo "--- Local (Internal) IPs ---"
local_ips

echo ""
echo "--- External (Public) IPs ---"
if command -v curl > /dev/null; then
    echo -n "IPv4: "
    curl -4 -s --max-time 5 ifconfig.me || echo -n "Unavailable"
    echo ""
    echo -n "IPv6: "
    curl -6 -s --max-time 5 checkip.amazonaws.com || echo -n "Unavailable"
    echo ""
else
    echo "Error: 'curl' is required for public IP check." >&2
    exit 1
fi

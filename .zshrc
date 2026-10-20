# ==========================================
# 1. ENVIRONMENT & PATH INITIALIZATION
# ==========================================

# --- ZSH Installation Path ---
export ZSH="$HOME/.oh-my-zsh"

# --- PATH Construction ---
# Rationale: User binaries ($HOME/bin) take precedence over system binaries.
# Termux's own $PREFIX/bin is already on PATH; no /usr/local or /snap here.
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# --- Editor Selection Strategy ---
# Priority: Neovim (Modern CLI) > Vi (Universal Fallback)
if command -v nvim &> /dev/null; then
    export EDITOR='nvim'
else
    export EDITOR='vi'
fi

# ==========================================
# 2. ZSH CORE & THEME
# ==========================================

ZSH_THEME="agnoster"

# --- Plugins ---
# Performance Note: Keep minimal. No 'sudo' plugin: Termux has no sudo.
plugins=(git nmap)

source $ZSH/oh-my-zsh.sh

# --- Navigation Enhancements ---
# Zoxide: Smarter 'cd' replacement
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# ==========================================
# 3. ALIASES: SYSTEM & MAINTENANCE
# ==========================================

# --- Dotfiles Version Control ---
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# --- Shell Management ---
alias cls='clear'
alias reload-zsh='source ~/.zshrc && echo "ZSH config reloaded."'
alias ep='$EDITOR ~/.zshrc'

# --- Process Management ---
alias p='ps aux | grep -v grep'                  # Quick search
alias ps='ps auxf'                               # Tree view
command -v htop &> /dev/null && alias top='htop'
# 'command' bypasses the ps alias above
alias topcpu='command ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10'

# ==========================================
# 4. ALIASES: NAVIGATION & DIRECTORIES
# ==========================================

# --- Traversal ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias bd='cd $OLDPWD'
alias z..='zoxide query ..'

# --- Modern Listing (EZA) ---
# Detects if eza is installed, falls back to ls if not.
if command -v eza &> /dev/null; then
    alias ls='eza --icons'
    alias ll='eza -l --icons'
    alias la='eza -la --icons'
else
    alias ls='ls --color=auto'
    alias ll='ls -l'
    alias la='ls -la'
fi

# ==========================================
# 5. ALIASES: NETWORK & DIAGNOSTICS
# ==========================================

alias checksmtp='$HOME/bin/checksmtp.sh'

# --- Core Networking ---
alias myip='whatsmyip'
# Ping Google DNS (Internet Connectivity Test)
alias pingg='ping 8.8.8.8'
# Ping Default Gateway (Local Connectivity Test)
# A function, not an alias: awk's $3 must not be expanded by the shell.
# Android may block 'ip route', so fail with a message instead of pinging nothing.
pinggw() {
    local gw
    gw=$(ip route show 2>/dev/null | awk '/default/ {print $3; exit}')
    [[ -n "$gw" ]] || { echo "pinggw: no default gateway (ip route unavailable?)" >&2; return 1; }
    ping "$gw"
}

# --- SMTP Connectivity Tools ---
# Base Command
alias cs='checksmtp'
alias testmail='checksmtp'
alias checkmail='checksmtp'

# --- Provider Library (Scan-to-Email Targets) ---
# NOTE: We pass the FQDN directly to bypass the script's internal dictionary.

# 1. Major Providers
alias csgmail='checksmtp smtp.gmail.com'
alias cso365='checksmtp smtp.office365.com'
alias csoutlook='checksmtp smtp-mail.outlook.com'
alias csyahoo='checksmtp smtp.mail.yahoo.com'
alias csaol='checksmtp smtp.aol.com'
alias csicloud='checksmtp smtp.mail.me.com'
alias cszoho='checksmtp smtp.zoho.com'

# 2. Transactional / Dev
alias csgo='checksmtp smtp.smtp2go.com'
alias cssendgrid='checksmtp smtp.sendgrid.net'
alias csmailgun='checksmtp smtp.mailgun.org'
alias cspostmark='checksmtp smtp.postmarkapp.com'
alias csmandrill='checksmtp smtp.mandrillapp.com'
alias csbrevo='checksmtp smtp-relay.sendinblue.com'
alias csmailjet='checksmtp in-v3.mailjet.com'
alias csses='checksmtp email-smtp.us-east-1.amazonaws.com'

# 3. ISP / Telecom (Common Legacy Setups)
alias cscomcast='checksmtp smtp.comcast.net'
alias csatt='checksmtp outbound.att.net'
alias csverizon='checksmtp smtp.verizon.net'
alias csspectrum='checksmtp mail.twc.com'
alias cscox='checksmtp smtp.cox.net'
alias cscentury='checksmtp smtp.centurylink.net'

# 4. Web Hosting
alias csgodaddy='checksmtp smtpout.secureserver.net'
alias csrackspace='checksmtp secure.emailsrvr.com'
alias csionos='checksmtp smtp.ionos.com'
alias csbluehost='checksmtp smtp.bluehost.com'

# ==========================================
# 6. MICRO FUNCTIONS
# ==========================================

cheat() { clear && curl cheat.sh/"$1" ; }
weather() { clear && curl wttr.in/"$1" ; }

# ==========================================
# 7. SESSION MANAGEMENT (ZELLIJ)
# ==========================================

if command -v zellij &> /dev/null; then
    # Prevent nested sessions and do not launch inside VS Code terminal
    if [[ -z "$ZELLIJ" && "$TERM_PROGRAM" != "vscode" ]]; then
        eval "$(zellij setup --generate-auto-start zsh)"
    fi
fi

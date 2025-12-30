# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return ;;
esac

###############################################################################
# History (timestamps + sane behaviour)
###############################################################################
# Show timestamps in `history` output:
#   %F = YYYY-MM-DD, %T = HH:MM:SS
export HISTTIMEFORMAT='%F %T  '

# Keep a reasonable amount of history
# Adjust if you want more/less.
export HISTSIZE=500000
export HISTFILESIZE=900000

# History behaviour
export HISTCONTROL=erasedups:ignoredups:ignorespace
export HISTIGNORE='ls:ll:l:la:pwd:exit:clear:history'

# Append to the history file, don't overwrite it
shopt -s histappend 2>/dev/null
shopt -s cmdhist 2>/dev/null

# Multi-session friendly history syncing
# without clobbering other PROMPT_COMMAND logic
__hist_sync() {
  builtin history -a   # append new lines to HISTFILE
  builtin history -n   # read new lines from HISTFILE
}
if [[ -z "${PROMPT_COMMAND:-}" ]]; then
  PROMPT_COMMAND="__hist_sync"
else
  case ";$PROMPT_COMMAND;" in
    *";__hist_sync;"*) : ;;
    *) PROMPT_COMMAND="__hist_sync; $PROMPT_COMMAND" ;;
  esac
fi

###############################################################################
# Shell behaviour
###############################################################################
# Check the window size after each command and update LINES/COLUMNS
shopt -s checkwinsize

# If set, the pattern "**" used in pathname expansion can match all dirs/subdirs.
# shopt -s globstar

# Identify chroot (Debian-style; harmless if not present)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

###############################################################################
# Prompt (last PS1 wins)
###############################################################################
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes ;;
esac

force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
  if command -v tput >/dev/null 2>&1 && tput setaf 1 >/dev/null 2>&1; then
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

case "$TERM" in
  xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
esac

###############################################################################
# ls/grep colours + handy aliases
###############################################################################
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias ll='ls -lsaFh --color=auto'
  alias l='ls -CF --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

###############################################################################
# Alias definitions
###############################################################################
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

###############################################################################
# Bash completion
###############################################################################
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

###############################################################################
# Global Alias Autocomplete
###############################################################################
shopt -s expand_aliases

_generic_alias_completion() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local alias_name="${COMP_WORDS[0]}"

  case "$alias_name" in
    filesearch)
      COMPREPLY=( $(compgen -f -- "$cur") )
      ;;
    viewapplogs)
      COMPREPLY=( $(compgen -W "$(systemctl list-units --type=service --no-pager --plain --no-legend 2>/dev/null | awk '{print $1}')" -- "$cur") )
      ;;
    helpcmd)
      COMPREPLY=( $(compgen -W "filesearch bigfiles showhidden editfile extract compress home cd.. .. ... .... ..... bd rmd viewsyslogs viewapplogs viewrebootlogs viewwarninglogs viewerrorlogs viewauthlogs lsof-established lsof-udp lsof-port lsof-listen lsof-network lsof-ipv4 lsof-ipv6 install remove purge autoremove search showupgrades updaterepo fullupdate showinstalledpkgs showpkgs showpackagefiles showpkgssize ipinfo netstatl cpuinfo meminfo diskinfo editbash reloadbash fullreload block-in-tcp block-fw-in-tcp block-fw-out-tcp" -- "$cur") )
      ;;
    *)
      COMPREPLY=()
      ;;
  esac
}

complete -F _generic_alias_completion filesearch viewapplogs helpcmd

###############################################################################
# Prompt override (If enabled, this wins because it's last)
###############################################################################
#PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '

###############################################################################
# Source ~/bash_aliases directory
###############################################################################
directory_path="$HOME/bash_aliases"

if [ -d "$directory_path" ]; then
  for file in "$directory_path"/*; do
    if [ -f "$file" ]; then
      if [ -r "$file" ]; then
        chmod +r "$file" 2>/dev/null
        source "$file"
      else
        echo "Error: File not readable - $file"
      fi
    else
      echo "Error: Not a regular file - $file"
    fi
  done
else
  echo "Error: Directory not found - $directory_path"
fi

###############################################################################
# Login banner / stats
###############################################################################
if [ -t 1 ]; then
  echo -e "\033[1m"
  fastfetch
  echo -e "\033[0m"

  if [ -n "$SSH_CONNECTION" ]; then
    echo -e "\n\033[1mSSH Connection IP:\033[0m $SSH_CLIENT"
  elif [ -n "$CONSOLE" ]; then
    echo -e "\n\033[1mConsole IP:\033[0m $(hostname -I 2>/dev/null)"
  fi

  # CPU load: user+sys percentage from top (best-effort)
  cpu_load="$(top -bn1 2>/dev/null | awk -F'[, ]+' '/Cpu\(s\)/{print $3+$5; exit}')"
  [ -n "$cpu_load" ] && echo -e "\n\033[1mCPU Load:\033[0m ${cpu_load}%"

  echo -e "\n\033[1mUptime:\033[0m $(uptime -p 2>/dev/null)"

  lastreboot="$(last reboot 2>/dev/null | head -n 1)"
  if [[ $lastreboot == *"(clean)"* ]]; then
    echo -e "\033[1mLast Reboot State:\033[0m Clean"
  else
    echo -e "\033[1mLast Reboot State:\033[0m Dirty"
  fi

  echo -e "\n\033[1mTo view system logs, use:\033[0m viewsyslogs"
  echo -e "\033[1mTo view specific application logs, use:\033[0m viewapplogs <application-name>"
  echo -e "\033[1mTo view reboot logs, use:\033[0m viewrebootlogs"
  echo -e "\033[1mTo view warning logs, use:\033[0m viewwarninglogs"
  echo -e "\033[1mTo view error logs, use:\033[0m viewerrorlogs"
  echo -e "\033[1mTo view authentication logs, use:\033[0m viewauthlogs"
fi

###############################################################################
# Custom aliases / tools
###############################################################################
# AutoJump (If installed and enabled)
[ -r /usr/share/autojump/autojump.sh ] && . /usr/share/autojump/autojump.sh

## Neovim configuration (legacy)
#export PATH="$PATH:/opt/nvim-linux64/bin"
#alias vim="nvim"
#alias vi="nvim"
#alias v="nvim"
#alias nano="nvim" # :)

## Simple test logic. (non-exhaustive)
## Neovim configuration (use nvim only if available)
#if [ -x /opt/nvim-linux64/bin/nvim ]; then
#  export PATH="$PATH:/opt/nvim-linux64/bin"
#  alias vim='nvim'
#  alias vi='nvim'
#  alias v='nvim'
#  alias nano='nvim'
#elif command -v nvim >/dev/null 2>&1; then
#  alias vim='nvim'
#  alias vi='nvim'
#  alias v='nvim'
#  alias nano='nvim'
#else
#  # Fall back to classic vim if Neovim isn't available
#  alias vi='vim'
#  alias v='vim'
#  alias nano='vim'
#  alias edit='vim'
#fi

# Default editor (nvim if available, otherwise vim, otherwise vi)
if [ -x /opt/nvim-linux64/bin/nvim ]; then
  export PATH="$PATH:/opt/nvim-linux64/bin"
  EDITOR_CMD='/opt/nvim-linux64/bin/nvim'
elif command -v nvim >/dev/null 2>&1; then
  EDITOR_CMD='nvim'
elif command -v vim >/dev/null 2>&1; then
  EDITOR_CMD='vim'
else
  EDITOR_CMD='vi'
fi

# Make NeoVIM / VIM the default editor for common tooling:
# - git: uses GIT_EDITOR, then core.editor, then VISUAL/EDITOR
# - crontab: uses VISUAL/EDITOR
# - visudo/sudoedit: uses SUDO_EDITOR, then VISUAL/EDITOR
# - systemctl edit: uses SYSTEMD_EDITOR
export VISUAL="$EDITOR_CMD"
export EDITOR="$EDITOR_CMD"
export GIT_EDITOR="$EDITOR_CMD"
export SUDO_EDITOR="$EDITOR_CMD"
export SYSTEMD_EDITOR="$EDITOR_CMD"

# Convenience aliases
alias edit="$VISUAL"

if [ "$EDITOR_CMD" = 'nvim' ] || [ "$EDITOR_CMD" = '/opt/nvim-linux64/bin/nvim' ]; then
  # If we're using Neovim, map everything to nvim
  alias vim="$VISUAL"
  alias vi="$VISUAL"
  alias v="$VISUAL"
  alias nano="$VISUAL"
else
  # If not using Neovim:
  # - leave vim alone (if installed)
  # - make vi/v use vim when available, otherwise vi
  if command -v vim >/dev/null 2>&1; then
    alias vi='vim'
    alias v='vim'
    alias nano='vim'
  else
    alias vim='vi'
    alias v='vi'
    alias nano='vi'
  fi
fi

unset EDITOR_CMD

# Help function for site tools
help_tools() {
  echo -e "\n\033[1;34mAvailable Site Monitoring & Security Commands:\033[0m"
  echo -e "  \033[1;32msc <website_url>\033[0m      → Quick connectivity check"
  echo -e "  \033[1;32msca <website_url>\033[0m     → Connectivity check (All HTTP Codes)"
  echo -e "  \033[1;32mfsd <website_url>\033[0m     → Full site diagnosis"
  echo -e "  \033[1;32mssa <website_url>\033[0m     → Security audit"
  echo -e "  \033[1;32masa <website_url>\033[0m     → Advanced security audit"
  echo -e "\nFor detailed help on each function, use: \033[1;33mhelp_<command>\033[0m"
}

help_sc()  { echo -e "\n\033[1;34msc (Site Checker)\033[0m\nChecks website connectivity, response time, and HTTP status."; }
help_sca() { echo -e "\n\033[1;34msca (All HTTP Codes Checker)\033[0m\nPerforms a detailed HTTP status check on a website."; }
help_fsd() { echo -e "\n\033[1;34mfsd (Full Site Diagnosis)\033[0m\nRuns multiple network tests, including DNS, ping, traceroute, and SSL validity."; }
help_ssa() { echo -e "\n\033[1;34mssa (Security Audit)\033[0m\nPerforms a basic security audit, including HTTP headers and SSL certificate analysis."; }
help_asa() { echo -e "\n\033[1;34masa (Advanced Security Audit)\033[0m\nConducts an in-depth security check, including subdomain risks, email security, and CSP verification."; }

alias sc='/usr/local/bin/sc'
alias fsd='/usr/local/bin/fsd'
alias asa='/usr/local/bin/asa'
alias sca='/usr/local/bin/sca'
alias ssa='/usr/local/bin/ssa'

###############################################################################
# SSL tools
###############################################################################
_ssl__pager() { command -v bat &>/dev/null && bat -l pem -p || less -R; }

_ssl__pick() {
  if [[ -z $1 && -t 1 ]] && command -v fzf &>/dev/null; then
    fzf --prompt="$2 › " --preview 'head -n 20 {}'
  elif [[ -z $1 ]]; then
    mapfile -t files < <(compgen -G "$2")
    [[ ${#files[@]} -eq 1 ]] && printf '%s\n' "${files[0]}"
  else
    printf '%s\n' "$1"
  fi
}

crt() {
  local file; file=$(_ssl__pick "$1" "*.crt"); [[ -z $file ]] && return
  openssl x509 -in "$file" -text -noout | _ssl__pager
}

cabun() {
  local file; file=$(_ssl__pick "$1" "*.ca-bundle"); [[ -z $file ]] && return
  local tmp; tmp=$(mktemp -d)
  csplit -sf "$tmp/ca_" "$file" '/-----BEGIN CERTIFICATE-----/' '{*}' &>/dev/null
  for pem in "$tmp"/ca_*; do
    echo -e "\e[1;36m── $(basename "$pem") ──────────────────────\e[0m"
    openssl x509 -in "$pem" -text -noout | _ssl__pager
  done
  rm -r "$tmp"
}

p7b() {
  local file; file=$(_ssl__pick "$1" "*.p7b"); [[ -z $file ]] && return
  local out="${file%.p7b}.pem"
  if openssl pkcs7 -print_certs -in "$file" -out "$out" 2>/dev/null; then
    echo -e "\e[32m✔ PEM saved to $out\e[0m"
  else
    openssl pkcs7 -inform der -print_certs -in "$file" -out "$out"
    echo -e "\e[32m✔ DER converted → $out\e[0m"
  fi
  crt "$out"
}

certchk() {
  [[ -z $2 ]] && { echo "Usage: certchk leaf.crt bundle.pem"; return 1; }
  openssl verify -CAfile "$2" "$1"
}

certexp() {
  local d; d=$(openssl x509 -enddate -noout -in "$1" | cut -d= -f2)
  # GNU date supports -d; if not available, it will just print the expiry line.
  if date -d "$d" +%s >/dev/null 2>&1; then
    printf "Expires: %s (in %s days)\n" "$d" "$(( ( $(date -d "$d" +%s) - $(date +%s) ) / 86400 ))"
  else
    printf "Expires: %s\n" "$d"
  fi
}

_complete_ssl()   { local cur=${COMP_WORDS[COMP_CWORD]}; COMPREPLY=( $(compgen -f -X '!*.crt' -- "$cur") ); }
_complete_cabun() { local cur=${COMP_WORDS[COMP_CWORD]}; COMPREPLY=( $(compgen -f -X '!*.ca-bundle' -- "$cur") ); }
_complete_p7b()   { local cur=${COMP_WORDS[COMP_CWORD]}; COMPREPLY=( $(compgen -f -X '!*.p7b' -- "$cur") ); }
complete -F _complete_ssl crt certchk certexp
complete -F _complete_cabun cabun
complete -F _complete_p7b p7b

###############################################################################
# qtriage (deduped)
###############################################################################
qtriage() { quickphptriage "$1"; }
alias qtriagereport=quickphptriage-report

# End of .bashrc


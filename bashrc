# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000000000
HISTFILESIZE=2000000000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
# We have color support; assume it's compliant with Ecma-48
# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
# a case would tend to support setf rather than setaf.)
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

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
;;
*)
;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
alias ls='ls --color=auto'
alias ll='ls -lsaFh --color=auto'
alias l='ls -CF --color=auto'
#alias dir='dir --color=auto'
#alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
if [ -f /usr/share/bash-completion/bash_completion ]; then
. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
. /etc/bash_completion
fi
fi
# ~/.bashrc

# Customize the prompt to show current user, host, and current directory
PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '

# Aliases for common commands
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# System administration aliases
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias purge='sudo apt purge'
alias autoremove='sudo apt autoremove'
alias search='apt search'
alias editbash='vim ~/.bashrc'
alias reloadbash='source ~/.bashrc'

# Network administration aliases
alias ipinfo='curl ipinfo.io'  # Show public IP information
alias netstatl='sudo netstat -tulpn'  # List all listening ports

# System information aliases
alias cpuinfo='lscpu'
alias meminfo='free -h'
alias diskinfo='df -h'

# Package management aliases
alias showpackages='dpkg -l'  # Show installed packages
alias showfiles='dpkg -L'     # Show files installed by a package
alias showsize='dpkg-query -W --showformat="\${Installed-Size;10}\t\${Package}\n" | sort -n'  # Show installed package sizes
alias upgrades='apt list --upgradable'  # Show available package upgrades
alias fullupdate='sudo apt full-upgrade -y'  # Upgrade packages, including kernel packages

# File management aliases
alias filesearch='find . -type f -iname'  # Search for files by name
alias bigfiles='du -h --max-depth=1 | sort -hr'  # List largest files in the current directory
alias showhidden='ls -ld .*'  # Show hidden files and directories
alias editfile='vim'  # Open a text file for editing with nano

# Archive management aliases
alias extract='tar -zxvf'  # Extract a tar.gz archive
alias compress='tar -zcvf'  # Create a tar.gz archive

# Help command to display aliases and functions with explanations
function help() {
echo -e "\n\033[1;36mFile Management Commands:\033[0m"
echo -e "- \033[1mls\033[0m: List files with color highlighting"
echo -e "- \033[1mll\033[0m: List detailed information about files"
echo -e "- \033[1mla\033[0m: List all files, including hidden ones"
echo -e "- \033[1ml\033[0m: List files in a compact format"
echo -e "- \033[1mfilesearch\033[0m: Search for files by name"
echo -e "- \033[1mbigfiles\033[0m: List largest files in the current directory"
echo -e "- \033[1mshowhidden\033[0m: Show hidden files and directories"
echo -e "- \033[1meditfile\033[0m: Open a text file for editing with nano"
echo -e "- \033[1mextract\033[0m: Extract files from a tar.gz archive"
echo -e "- \033[1mcompress\033[0m: Create a tar.gz archive"

echo -e "\n\033[1;36mSystem Management Commands:\033[0m"
echo -e "- \033[1mupdate\033[0m: Update package lists and upgrade installed packages"
echo -e "- \033[1minstall\033[0m: Install a package"
echo -e "- \033[1mremove\033[0m: Remove a package"
echo -e "- \033[1mpurge\033[0m: Remove a package along with its configuration files"
echo -e "- \033[1mautoremove\033[0m: Remove packages that are no longer needed"
echo -e "- \033[1msearch\033[0m: Search for a package"
echo -e "- \033[1meditbash\033[0m: Open the .bashrc file for editing"
echo -e "- \033[1mreloadbash\033[0m: Reload the .bashrc file"
echo -e "- \033[1mipinfo\033[0m: Show public IP information"
echo -e "- \033[1mnetstatl\033[0m: List all listening ports"
echo -e "- \033[1mcpuinfo\033[0m: Show CPU information"
echo -e "- \033[1mmeminfo\033[0m: Show memory information"
echo -e "- \033[1mdiskinfo\033[0m: Show disk space information"
echo -e "- \033[1msystemloadgraph\033[0m: Generate system load graphs for the last 5, 10, and 15 minutes"
echo -e "- \033[1mupdatesystem\033[0m: Update system packages without installing new packages"

echo -e "\n\033[1;36mPackage Management Commands:\033[0m"
echo -e "- \033[1mshowpackages\033[0m: Show installed packages"
echo -e "- \033[1mshowfiles\033[0m: Show files installed by a package"
echo -e "- \033[1mshowsize\033[0m: Show installed package sizes"
echo -e "- \033[1mupgrades\033[0m: Show available package upgrades"
echo -e "- \033[1mfullupdate\033[0m: Upgrade packages, including kernel packages"

echo -e "\n\033[1;36mLogging and Analysis Commands:\033[0m"
echo -e "- \033[1mviewsyslogs\033[0m: View system logs"
echo -e "- \033[1mviewapplogs\033[0m: View specific application logs (Usage: viewapplogs <application-name>)"
echo -e "- \033[1mviewrebootlogs\033[0m: View reboot logs"
echo -e "- \033[1mviewwarninglogs\033[0m: View warning logs"
echo -e "- \033[1mviewerrorlogs\033[0m: View error logs"
echo -e "- \033[1mviewauthlogs\033[0m: View authentication logs"

echo -e "\n\033[1;36mHelp Commands:\033[0m"
echo -e "- \033[1mhelp\033[0m: Display this help message\n"
}


# Custom functions
# Add your own custom functions here


function restartservice() {
sudo systemctl restart $1
}

function startservice() {
sudo systemctl start $1
}

function stopservice() {
sudo systemctl stop $1
}

function findfile() {
find . -type f -iname "*$1*"
}


# Function to view system logs
function viewsyslogs() {
journalctl
}

# Function to view specific application logs
function viewapplogs() {
if [ -z "$1" ]; then
echo "Usage: viewapplogs <application-name>"
else
journalctl -u $1
fi
}

# Function to view reboot logs
function viewrebootlogs() {
journalctl -b
}

# Function to view warning logs
function viewwarninglogs() {
journalctl -p warning
}

# Function to view error logs
function viewerrorlogs() {
journalctl -p err
}

# Function to view authentication logs
function viewauthlogs() {
journalctl -t sudo
}

# Function to view load avg graphs
function systemloadgraph() {
echo "Generating system load graphs..."

# Extract load averages from /proc/loadavg
load_5min=$(awk '{print $1}' /proc/loadavg)
load_10min=$(awk '{print $2}' /proc/loadavg)
load_15min=$(awk '{print $3}' /proc/loadavg)

# Create data file for gnuplot
echo -e "5min\t$load_5min\n10min\t$load_10min\n15min\t$load_15min" > /tmp/loadavg.dat

# Create gnuplot script
cat <<GNUPLOT_SCRIPT > /tmp/loadavg.gp
set terminal dumb
set title "System Load Averages"
set xlabel "Time Interval"
set ylabel "Load Average"
set xtics nomirror
set ytics nomirror
set style fill solid
plot "/tmp/loadavg.dat" using 2:xtic(1) with boxes title "Load Average"
GNUPLOT_SCRIPT

# Plot the graphs
gnuplot /tmp/loadavg.gp

# Remove temporary files
rm /tmp/loadavg.dat /tmp/loadavg.gp
}

# Function to update system packages without installing new packages
function updatesystem() {
echo "Updating system packages without installing new packages..."
sudo apt-get update
sudo apt-get -o Dpkg::Options::="--force-confold" dist-upgrade --only-upgrade
}

# Display neofetch, IP address, CPU load, uptime, and last reboot state when starting an interactive shell
if [ -t 1 ]; then
echo -e "\033[1m"
neofetch
echo -e "\033[0m"

# Display IP address
if [ -n "$SSH_CONNECTION" ]; then
echo -e "\n\033[1mSSH Connection IP:\033[0m $SSH_CLIENT"
elif [ -n "$CONSOLE" ]; then
echo -e "\n\033[1mConsole IP:\033[0m $(hostname -I)"
fi

# Display CPU load
echo -e "\n\033[1mCPU Load:\033[0m $(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')%"

# Display system uptime
echo -e "\n\033[1mUptime:\033[0m $(uptime -p)"

# Display last reboot state
lastreboot=$(last reboot | grep -E "reboot" | head -n 1)
if [[ $lastreboot == *"(clean)"* ]]; then
echo -e "\033[1mLast Reboot State:\033[0m Clean"
else
echo -e "\033[1mLast Reboot State:\033[0m Dirty"
fi

# Provide instructions to view various logs
echo -e "\n\033[1mTo view system logs, use:\033[0m viewsyslogs"
echo -e "\033[1mTo view specific application logs, use:\033[0m viewapplogs <application-name>"
echo -e "\033[1mTo view reboot logs, use:\033[0m viewrebootlogs"
echo -e "\033[1mTo view warning logs, use:\033[0m viewwarninglogs"
echo -e "\033[1mTo view error logs, use:\033[0m viewerrorlogs"
echo -e "\033[1mTo view authentication logs, use:\033[0m viewauthlogs"
fi

# End of .bashrc

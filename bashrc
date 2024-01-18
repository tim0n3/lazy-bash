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

# Custom functions

directory_path="$HOME/bash_aliases"

# Check if the directory exists
if [ -d "$directory_path" ]; then
    # Loop through each file in the directory
    for file in "$directory_path"/*; do
        # Uncomment to output the current file being processed
        #echo "Processing file: $file"

        # Check if the file is a regular file
        if [ -f "$file" ]; then
            # Check if the file is readable
            if [ -r "$file" ]; then
                # Uncomment to output the permission change
                #echo "Changing permissions for $file"
                chmod +r "$file"

                # Source the file
		# Uncomment to output sourcing the file
                #echo "Sourcing $file"
                source "$file"
            else
                # Output an error if the file is not readable
                echo "Error: File not readable - $file"
            fi
        else
            # Output an error if the file is not a regular file
            echo "Error: Not a regular file - $file"
        fi
    done
else
    # Output an error if the directory does not exist
    echo "Error: Directory not found - $directory_path"
fi


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

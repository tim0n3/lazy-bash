#!/bin/env bash

# Automated Installation Script
# Author: [tim0n3]
# Version: 1.0
# Description: This script automates the process of installing lazy-bash on a system.
#              It allows users to take a chill-pill while this script does it's magic,
#              Error handling mechanisms are included to ensure smooth operation and logging
#              of any encountered issues.

# Uncomment the following line to enable debug output in the terminal.
# set -x

dir="$HOME/lazy_bash"
aliasdir="$HOME/bash_aliases"

log() {
	local message="$1"
	local log_file="/var/log/$(date +"%Y-%m-%d_%T")-install-security-updates-util.log"

	echo "$(date +"%Y-%m-%d %T"): $message" >&2
	echo "$(date +"%Y-%m-%d %T"): $message" >> "$log_file"

}

error() {
	echo "$(date +"%Y-%m-%d %T"): Error: $1" >&2
	log "Error: $1" >&2

	exit 1
}

fetchrepo() {
	log "Preparing environment\n"
	sleep 1
	log "Fetching repo and installing shell overhaul.\n"
	sleep 1
	git clone https://github.com/tim0n3/lazy-bash.git "$dir" && cd "$dir" || {
		error "Unable to fetch lazy-bash from git."
	}
}

installdeps() {
	cp -R "$dir/bash_aliases" "$HOME/" || {
		error "Error: Failed to copy bash_aliases directory."
	}
	cat "$dir/bashrc" > "$HOME/.bashrc" || {
		error "Error: Failed to overwrite your .bashrc file."
	}
	cd "$HOME" || exit 1
}

reloadshell() {
	source "$HOME/.bashrc" || {
		error "Error: Failed to source "$HOME/.bashrc" file."
	}
}

preinstallcleanup() {
	log "Cleaning up leftovers\n"
	rm -rf "$dir" "$aliasdir" || {
		error "preinstall_cleanup failed with"$?""
	}
}

postinstallcleanup() {
	log "Cleaning up leftovers\n"
	rm -rf "$dir" || {
		error "Failed to tidy up."
	}
}

upgradebash() {
	echo Upgrading bash
	preinstallcleanup
	fetchrepo
	installdeps
	reloadshell
	postinstallcleanup
	sleep 2
}

freshinstall() {
	echo Installing bash
	fetchrepo
	installdeps
	reloadshell
	postinstallcleanup
}

if [ -d "$HOME/bash_aliases" ]; then
	upgradebash || {
		error "Error: Failed to upgrade bash."
	}
else
	freshinstall || {
		error "Error: Failed to install bash."
	}
fi

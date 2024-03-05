#!/bin/env bash

# Automated Backup Script
# Author: [tim0n3]
# Version: 1.0
# Description: This script automates the process of creating backups for specified directories on a system.
#              It allows users to define which directories to backup, the destination directory for backups,
#              and a backup schedule. The script utilizes standard Unix utilities such as tar for creating backups,
#              and cron for scheduling. Error handling mechanisms are included to ensure smooth operation and logging
#              of any encountered issues.

# Uncomment the following line to enable debug output in the terminal.
# set -x

dir="$HOME/lazy_bash"
aliasdir="$HOME/bash_aliases"

# Function to log messages to stderr and a log file
log() {
	local message="$1"
	local log_file="/var/log/$(date +"%Y-%m-%d_%T")-install-security-updates-util.log"

	echo "$(date +"%Y-%m-%d %T"): $message" >&2
	echo "$(date +"%Y-%m-%d %T"): $message" >> "$log_file"

}

# Function to handle errors
error() {
	echo "$(date +"%Y-%m-%d %T"): Error: $1" >&2
	log "Error: $1" >&2

	exit 1
}

fetchrepo() {
	# Clone git repo
	log "Preparing environment\n"
	sleep 1
	log "Fetching repo and installing shell overhaul.\n"
	sleep 1
	git clone https://github.com/tim0n3/lazy-bash.git "$dir" && cd "$dir" || {
        error "Unable to fetch lazy-bash from git."
    }
}

installdeps() {
	# Copy libraries to the user's home folder
	cp -R "$dir/bash_aliases" "$HOME/" || {
        error "Error: Failed to copy bash_aliases directory."
    }

	# Overwrite the current .bashrc and load the new shell features
	cat "$dir/bashrc" > "$HOME/.bashrc" || {
        error "Error: Failed to overwrite your .bashrc file."
    }
    cd "$HOME" || exit 1
}

reloadshell() {
	# Go $Home and reload the shell
	source "$HOME/.bashrc" || {
        error "Error: Failed to source "$HOME/.bashrc" file."
    }
}

preinstallcleanup() {
	# Remove detected folders with the same name as git repo
	log "Cleaning up leftovers\n"
	rm -rf "$dir" "$aliasdir" || {
        error "preinstall_cleanup failed with"$?""
    }
}

postinstallcleanup() {
	# Remove detected folders with the same name as git repo
	log "Cleaning up leftovers\n"
	rm -rf "$dir" || {
        error "Failed to tidy up."
    }
}

# Main function
# Check ~/bash_aliases dir exists and cleanup else proceed \
# with a normal installation:
if [ -d "$HOME/bash_aliases" ]; then
	# Directory exists == redownload
	preinstallcleanup
	fetchrepo
	installdeps
	reloadshell
    postinstallcleanup
	sleep 2
else
	# Directory doesn't exist == business as usual
	fetchrepo
	installdeps
	reloadshell
    postinstallcleanup
fi


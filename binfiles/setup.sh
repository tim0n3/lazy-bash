#!/bin/env bash

dir="$HOME/lazy_bash"
aliasdir="$HOME/bash_aliases"

function fetchrepo() {
	# Clone git repo
	echo -e "Preparing environment\n"
	sleep 1
	echo -e "Fetching repo and installing shell overhaul.\n"
	sleep 1
	git clone https://github.com/tim0n3/lazy-bash.git "$dir" && cd "$dir" || exit 1
}

function installdeps() {
	# Copy libraries to the user's home folder
	cp -R "$dir/bash_aliases" "$HOME/"

	# Overwrite the current .bashrc and load the new shell features
	cat "$dir/bashrc" > "$HOME/.bashrc" && cd "$HOME" || exit 1
}

function reloadshell() {
	# Go $Home and reload the shell
	source "$HOME/.bashrc"
}

function cleanup() {
	# Remove detected folders with the same name as git repo
	echo -e "Cleaning up leftovers\n"
	rm -rf "$dir" "$aliasdir"
}

# Main function
# Check ~/bash_aliases dir exists and cleanup else proceed \
# with a normal installation:
if [ -d "$HOME/bash_aliases" ]; then
	# Directory exists == redownload
	cleanup
	fetchrepo
	installdeps
	reloadshell
#	cleanup
	sleep 2
else
	# Directory doesn't exist == business as usual
	fetchrepo
	installdeps
	reloadshell
#	cleanup
fi


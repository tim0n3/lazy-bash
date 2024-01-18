#!/bin/bash

dir="$HOME/lazy_bash"

function fetchrepo() {
	# Clone git repo
	echo -e "Preparing environment\n"
	sleep 2
	echo -e "Fetching repo and installing shell overhaul.\n"
	git clone https://github.com/tim0n3/lazy-bash.git && cd lazy-bash
}	

function installdeps() {
	# copy libraries to the user's home folder
	cp -R bash_aliases ~/

	# overwrite the current .bashrc and load the new shell features
	cat bashrc > ~/.bashrc && cd ~/
}

function reloadshell() {
	# Go $Home and reload the shell
	source ~/.bashrc
	reloadbash
}


function cleanup() {
	# Remove detected folders with same name as git repo
	echo -e "Cleaning up left overs\n"
	rm -rf ~/lazy-bash
}

# Main function
# Check ~/bash_aliases dir exists and cleaup else proceed \
# with a normal installation:
if [ -d ! "$HOME/bash_aliases" ]; then
	# Directory exists == redownload
	cleaup
	fetchrepo
	installdeps
	reloadshell
	sleep 2
else
	# Directory doesn't exist == business as usual
	fetchrepo
	cleanup
fi

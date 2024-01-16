#!/bin/bash

dir=~/lazy_bash

function fetchrepo() {
# Clone git repo
git clone https://github.com/tim0n3/lazy-bash.git
# move into lazy-bash dir
cd lazy-bash
# copy libraries to the user's home folder
cp -R bash_aliases ~/
# overwrite the current .bashrc and load the new shell features
cat bashrc > ~/.bashrc && source ~/.bashrc
# Go $Home and reload the shell
cd ~/
clear && reloadbash
}

function cleanup() {
# Remove detected folders with same name as git repo
echo -e "Cleaning up left overs\n"
rm -rf ~/lazy-bash
}

#
if [ -d ! ./bash_aliases ]; then
# Directory exists
fetchrepo;
else
# Directory doesn't exist
echo -e "Preparing environment\n"
cleanup;
echo -e "Fetching repo and installing shell overhaul.\n"
fetchrepo
fi

#!/bin/bash

dir=./lazy_bash

function fetchrepo() {
# Clone git repo
git clone https://github.com/tim0n3/lazy-bash.git && cd lazy-bash
sleep 2
# copy libraries to the user's home folder
cp -R bash_aliases ~/
sleep 2
# overwrite the current .bashrc and load the new shell features
cat bashrc > ~/.bashrc && source ~/.bashrc
sleep 2
# Go $Home and reload the shell
cd ~/
reloadbash
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
sleep 2
else
# Directory doesn't exist
echo -e "Preparing environment\n"
cleanup;
sleep 2
echo -e "Fetching repo and installing shell overhaul.\n"
fetchrepo
fi

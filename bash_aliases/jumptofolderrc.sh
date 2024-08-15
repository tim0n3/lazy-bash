#!/usr/bin/env bash
#
# This will be the function that performs and autojump to a directory when \
# calling a shortcut eg j or hop foldername


# Change directory aliases
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# cd into the old directory
alias bd='cd "$OLDPWD"'

# Remove a directory and all files
alias rmd='rm  -rf --verbose '

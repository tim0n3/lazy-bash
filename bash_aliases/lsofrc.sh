#!/bin/env bash

# Alias to list established TCP connections
alias lsof-established='lsof -ni TCP | grep ESTABLISHED'

# Alias to list UDP connections
alias lsof-udp='lsof -ni UDP'

# Alias to list processes using a specific port
alias lsof-port='lsof -ni :'

# Alias to list listening ports
alias lsof-listen='lsof -ni TCP | grep LISTEN'

# Alias to show network connections with associated processes
alias lsof-network='lsof -i -P'

# Alias to show only IPv4 network connections
alias lsof-ipv4='lsof -i 4'

# Alias to show only IPv6 network connections
alias lsof-ipv6='lsof -i 6'

# Alias to display detailed information about a specific file descriptor
alias lsof-descriptor='lsof -d'

# Alias to show files opened by a specific user
alias lsof-user-files='lsof -u'

# Alias to show files opened by a specific command
alias lsof-command-files='lsof -c'

# Alias to show files opened by a specific process ID
alias lsof-process-files='lsof -p'

# Alias to show files opened by a specific program name
alias lsof-program-files='lsof -c'

# Alias to show files opened by a specific user and process name
alias lsof-user-process='lsof -u -c'

# Alias to show files opened by a specific directory
alias lsof-directory='lsof +D'

# Alias to show files opened by a specific device
alias lsof-device='lsof -N'

# Alias to show process information for a specific file
alias lsof-file-process='lsof '

# Alias to show process information for a specific port
alias lsof-port-process='lsof -i : -P'

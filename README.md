# lazy-bash
This is lazy-bash. I made this because I was tired of using the long commands required to administer linux systems. It's designed to be modular and extensible, making it simple for customizations to streamline common tasks

## Features

### Prompt Customization
- The prompt displays the current user, host, and working directory.
- Colored prompt for better visibility.

### Aliases for Common Commands
- `ls` aliases for color-coded listing (`ls --color=auto`), detailed listing (`ll`), and showing all files (`la`).
- Additional system administration aliases for package management (`update`, `install`, `remove`, `purge`, `autoremove`, `search`), editing `.bashrc` (`editbash`), and reloading `.bashrc` (`reloadbash`).

### Network Administration Aliases
- `ipinfo`: Shows public IP information.
- `netstatl`: Lists all listening ports.

### System Information Aliases
- `cpuinfo`: Displays CPU information.
- `meminfo`: Displays memory information.
- `diskinfo`: Displays disk space information.

### Package Management Aliases
- `showpackages`: Shows installed packages.
- `showfiles`: Shows files installed by a package.
- `showsize`: Shows installed package sizes.
- `upgrades`: Shows available package upgrades.
- `fullupdate`: Upgrades packages, including kernel packages.

### File Management Aliases
- `filesearch`: Searches for files by name.
- `bigfiles`: Lists the largest files in the current directory.
- `showhidden`: Shows hidden files and directories.
- `editfile`: Opens a text file for editing with Vim.

### Archive Management Aliases
- `extract`: Extracts files from a tar.gz archive.
- `compress`: Creates a tar.gz archive.

### Custom Functions
- `restartservice`: Restarts a systemd service.
- `startservice`: Starts a systemd service.
- `stopservice`: Stops a systemd service.
- `findfile`: Finds a file by name.

### Logging and Analysis Commands
- `viewsyslogs`: Views system logs.
- `viewapplogs <application-name>`: Views specific application logs.
- `viewrebootlogs`: Views reboot logs.
- `viewwarninglogs`: Views warning logs.
- `viewerrorlogs`: Views error logs.
- `viewauthlogs`: Views authentication logs.

### System Information Display on Shell Startup
- Displays system information including neofetch output, IP address, CPU load, uptime, and last reboot state when starting an interactive shell.

### Help Command
- `help`: Displays a comprehensive help message explaining all aliases and functions.

## Installation

Before using the installation script, make sure you have the following dependencies installed:

### Dependencies

- **curl**: Used to download the customized `.bashrc` file from a GitHub raw link.
- **neofetch**: Displays system information when starting an interactive shell.
- **iptables**: Manages the netfilter firewall rules for IPv4.
- **netstat**: Displays network connections, routing tables, interface statistics, masquerade connections, and multicast memberships.
- **gnuplot**: Generates system load graphs for the last 5, 10, and 15 minutes.

Ensure these dependencies are installed using your system's package manager. For example, on a Debian-based system, you can install them using the following commands:

```bash
sudo apt-get install curl neofetch iptables net-tools gnuplot
```

After ensuring that all dependencies are installed, you can use the provided installation script:

To install this customized `.bashrc` configuration, you can paste the following script in your terminal or run it from a file:

```bash
#!/bin/bash

function newbashrc() {
    # GitHub raw link to the file you want to append
    github_raw_link="https://raw.githubusercontent.com/tim0n3/lazy-bash/main/bashrc"

    # Local path to the .bashrc file
    bashrc_path="$HOME/.bashrc"

    # Download the file from the GitHub raw link
    content=$(curl -sSL "$github_raw_link")

    # Check if the download was successful
    if [ -n "$content" ]; then
        # Append the contents to the .bashrc file
        echo -e "\n# Appended from $github_raw_link\n$content" >> "$bashrc_path"
        echo "Contents appended to $bashrc_path"
    else
        echo "Failed to download the file from $github_raw_link"
    fi
}

# Run the installation script
newbashrc
```

Feel free to customize the aliases, functions, and settings to suit your preferences and workflow.

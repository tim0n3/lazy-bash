#!/bin/bash

# Function to view all iptables firewall rules with color formatting
viewfirewall() {
    echo -e "Viewing all iptables firewall rules...\n"

    echo -e "\033[1;36mIncoming Rules:\033[0m"
    sudo iptables -L INPUT -v -n --line-numbers

    echo -e "\n\033[1;36mForward Rules:\033[0m"
    sudo iptables -L FORWARD -v -n --line-numbers

    echo -e "\n\033[1;36mOutgoing Rules:\033[0m"
    sudo iptables -L OUTPUT -v -n --line-numbers

    echo -e "\n\033[1;36mNAT Rules:\033[0m"
    sudo iptables -t nat -L -v -n --line-numbers

    echo -e "\n\033[1;36mMangle Rules:\033[0m"
    sudo iptables -t mangle -L -v -n --line-numbers

    echo -e "\n\033[1;36mRaw Rules:\033[0m"
    sudo iptables -t raw -L -v -n --line-numbers
}

# block specific TCP ports to the host device/router.
block-in-tcp() {
    local port=$1
    local comment=''
    # Print success message indicating the rule has been added
    echo -e "\n\033[1;32mSuccess:\033[0m Added iptables rule to block TCP traffic with source port $sport"
    echo -e "\n\033[1;32mDisplaying:\033[0m Updated iptables rules"
    echo -e "\n\033[1;36mForward Rules:\033[0m"
    sudo iptables -L FORWARD -v -n --line-numbers
    # Print success message indicating the rule has been added
    echo -e "\n\033[1;32mSuccess:\033[0m Added iptables rule to block TCP traffic with source port $sport"
    echo -e "\n\033[1;32mDisplaying:\033[0m Updated iptables rules"
    echo -e "\n\033[1;36mForward Rules:\033[0m"
    sudo iptables -L FORWARD -v -n --line-numbers
    # Print success message indicating the rule has been added
    echo -e "\n\033[1;32mSuccess:\033[0m Added iptables rule to block TCP traffic with source port $sport"
    echo -e "\n\033[1;32mDisplaying:\033[0m Updated iptables rules"
    echo -e "\n\033[1;36mForward Rules:\033[0m"
    sudo iptables -L FORWARD -v -n --line-numbers
    # Print success message indicating the rule has been added
    echo -e "\n\033[1;32mSuccess:\033[0m Added iptables rule to block TCP traffic with source port $sport"
    echo -e "\n\033[1;32mDisplaying:\033[0m Updated iptables rules"
    echo -e "\n\033[1;36mForward Rules:\033[0m"
    sudo iptables -L FORWARD -v -n --line-numbers
    # Print success message indicating the rule has been added
    echo -e "\n\033[1;32mSuccess:\033[0m Added iptables rule to block TCP traffic with source port $sport"
    echo -e "\n\033[1;32mDisplaying:\033[0m Updated iptables rules"
    echo -e "\n\033[1;36mForward Rules:\033[0m"
    sudo iptables -L FORWARD -v -n --line-numbers
    # Print success message indicating the rule has been added
    echo -e "\n\033[1;32mSuccess:\033[0m Added iptables rule to block TCP traffic with source port $sport"
    echo -e "\n\033[1;32mDisplaying:\033[0m Updated iptables rules"
    echo -e "\n\033[1;36mForward Rules:\033[0m"
    sudo iptables -L FORWARD -v -n --line-numbers

    # Parse arguments
    shift
    while [[ $# -gt 0 ]]; do
        case "$1" in
            comment)
                comment=$2
                shift
                ;;
            *)
                echo -e "\n\033[1;31mError:\033[0m Unknown option: $1"
                return 1
                ;;
        esac
        shift
    done

    # Check if port is provided
    if [[ -z $port ]]; then
        echo -e "\n\033[1;31mError:\033[0m Port is required."
        return 1
    fi

    # Add rule to iptables input chain
    if [[ -n $comment ]]; then
        iptables -A INPUT -p tcp -m tcp --dport $port -j REJECT --reject-with tcp-reset -m comment --comment "$comment"
        echo -e "\n\033[1;32mSuccess:\033[0m Added iptables rule to block TCP port $port with comment '$comment'"
	# Print success message indicating the rule has been added
	echo -e "\n\033[1;32mSuccess:\033[0m Added iptables rule to block TCP traffic on destination port $dport"
	echo -e "\n\033[1;32mDisplaying:\033[0m Updated iptables rules"
	echo -e "\033[1;36mIncoming Rules:\033[0m"
	sudo iptables -L INPUT -v -n --line-numbers
    else
        iptables -A INPUT -p tcp -m tcp --dport $port -j REJECT --reject-with tcp-reset
        echo -e "\n\033[1;32mSuccess:\033[0m Added iptables rule to block TCP port $port"
	# Print success message indicating the rule has been added
	echo -e "\n\033[1;32mSuccess:\033[0m Added iptables rule to block TCP traffic on destination port $dport"
	echo -e "\n\033[1;32mDisplaying:\033[0m Updated iptables rules"
	echo -e "\033[1;36mIncoming Rules:\033[0m"
	sudo iptables -L INPUT -v -n --line-numbers
    fi
}

# The intention is to \
# block specific TCP ports to the LAN from the WAN.
# You may use this in a multi-LAN setup.
# Contextually the logic for these rules are that \
# you structure them with the mindset being your primrary \
# LAN is the destination i.e. the internal network and \
# anything else being external to it.
block-fw-in-tcp() {
    # Initialize variables for destination port, source port, inbound interface,
    # outbound interface, and comment
    local dport=''
    local sport=''
    local in_interface=''
    local out_interface=''
    local comment=''

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dport)
                dport=$2
                shift 2
                ;;
            --sport)
                sport=$2
                shift 2
                ;;
            --in-interface)
                in_interface=$2
                shift 2
                ;;
            --out-interface)
                out_interface=$2
                shift 2
                ;;
            comment)
                comment=$2
                shift 2
                ;;
            *)
                # If an unknown option is provided, print an error message
                echo -e "\n\033[1;31mError:\033[0m Unknown option: $1"
                return 1
                ;;
        esac
    done

    # Check mandatory arguments (destination port and inbound interface)
    if [[ -z $dport || -z $in_interface ]]; then
        echo -e "\n\033[1;31mError:\033[0m Destination port (--dport) and inbound interface (--in-interface) are required."
        return 1
    fi

    # Construct the rule dynamically based on the provided arguments
    local rule="iptables -A FORWARD -p tcp --dport $dport"

    # Append source port to the rule if provided
    [[ -n $sport ]] && rule+=" --sport $sport"

    # Append inbound interface to the rule if provided
    [[ -n $in_interface ]] && rule+=" -i $in_interface"

    # Append outbound interface to the rule if provided
    [[ -n $out_interface ]] && rule+=" -o $out_interface"

    # Add action to reject TCP traffic with a TCP reset
    rule+=" -j REJECT --reject-with tcp-reset"

    # Append comment to the rule if provided
    [[ -n $comment ]] && rule+=" -m comment --comment '$comment'"

    # Add the constructed rule to iptables
    eval "$rule"

    # Print success message indicating the rule has been added
    echo -e "\n\033[1;32mSuccess:\033[0m Added iptables rule to block TCP traffic with source port $sport"
    echo -e "\n\033[1;32mDisplaying:\033[0m Updated iptables rules"
    echo -e "\n\033[1;36mForward Rules:\033[0m"
    sudo iptables -L FORWARD -v -n --line-numbers

}

block-fw-out-tcp() {
    # Initialize variables for source port, destination port, outbound interface,
    # inbound interface, and comment
    local sport=''
    local dport=''
    local out_interface=''
    local in_interface=''
    local comment=''

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --sport)
                sport=$2
                shift 2
                ;;
            --dport)
                dport=$2
                shift 2
                ;;
            --out-interface)
                out_interface=$2
                shift 2
                ;;
            --in-interface)
                in_interface=$2
                shift 2
                ;;
            comment)
                comment=$2
                shift 2
                ;;
            *)
                # If an unknown option is provided, print an error message
                echo -e "\n\033[1;31mError:\033[0m Unknown option: $1"
                return 1
                ;;
        esac
    done

    # Check mandatory arguments (source port and outbound interface)
    if [[ -z $sport || -z $out_interface ]]; then
        echo -e "\n\033[1;31mError:\033[0m Source port (--sport) and outbound interface (--out-interface) are required."
        return 1
    fi

    # Construct the rule dynamically based on the provided arguments
    local rule="iptables -A FORWARD -p tcp"

    # Append source port to the rule if provided
    [[ -n $sport ]] && rule+=" --sport $sport"

    # Append destination port to the rule if provided
    [[ -n $dport ]] && rule+=" --dport $dport"

    # Append outbound interface to the rule if provided
    [[ -n $out_interface ]] && rule+=" -o $out_interface"

    # Append inbound interface to the rule if provided
    [[ -n $in_interface ]] && rule+=" -i $in_interface"

    # Add action to reject TCP traffic with a TCP reset
    rule+=" -j REJECT --reject-with tcp-reset"

    # Append comment to the rule if provided
    [[ -n $comment ]] && rule+=" -m comment --comment '$comment'"

    # Add the constructed rule to iptables
    eval "$rule"

    # Print success message indicating the rule has been added
    echo -e "\n\033[1;32mSuccess:\033[0m Added iptables rule to block TCP traffic with source port $sport"
    echo -e "\n\033[1;32mDisplaying:\033[0m Updated iptables rules"
    echo -e "\n\033[1;36mForward Rules:\033[0m"
    sudo iptables -L FORWARD -v -n --line-numbers

}


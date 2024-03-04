#!/bin/bash

# Function to extract MAC addresses from the nmap output
extract_mac_addresses() {
    grep -oE '([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})'
}

# Function to search for a MAC address in the text file and print the corresponding name
search_mac_in_file() {
    local mac_address="$1"
    local name=$(grep -i "$mac_address" "$mac_file" | cut -d'=' -f2 | tr -d '[:space:]')
    if [ -z "$name" ]; then
        echo -e "MAC Address: $mac_address, \033[0;31mINTRUDER\033[0m"
    else
        echo "MAC Address: $mac_address, Name: $name"
    fi
}


# Define the path to the text file containing MAC addresses and corresponding names
mac_file="list.txt"

# Loop indefinitely
while true; do
    # Echo the current date and time
    echo "---+ Current time: $(date '+%Y-%m-%d %H:%M:%S') +---"

    # Run the nmap command and store the output in a variable
    # change your target here
    nmap_output=$(sudo nmap -sn 192.168.1.0/24)

    # Extract MAC addresses from the nmap output
    mac_addresses=$(echo "$nmap_output" | extract_mac_addresses)

    # Iterate over each MAC address and search for it in the text file
    while IFS= read -r mac_address; do
        search_mac_in_file "$mac_address"
    done <<< "$mac_addresses"

    echo "---+ + +---"

    # Wait for 300 seconds before running the loop again
    sleep 300
done

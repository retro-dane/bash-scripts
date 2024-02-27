#!/bin/bash

NEW_PASSWORD=''      # Set the new password for the user
NEW_USERNAME=''      # Set the username of the user whose password will be changed
SERVERLIST=''        # Path to file containing list of servers to connect to

# Disclaimer: This script must be executed from a server that has keyless authentication set up for all servers listed in SERVERLIST.

# Loop through each server in the list
for i in $(cat $SERVERLIST); do
    # Connect to the current server via SSH and change the password for the specified username
    ssh $i "echo $NEW_PASSWORD | passwd $NEW_USERNAME --stdin"
done

# Exit the script after completing the task for all servers
exit

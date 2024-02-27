#!/bin/bash
# Creation Date: February 13th 2022
# Description: This script checks if a user is created on multiple Linux Servers

# Disclaimer: This script requires a jump box to access the servers listed in the SERVERLIST.

USERNAME="someUser"  # Specify the username to check

# Loop through each server in the list
for i in $(cat $SERVERLIST); do
    # SSH into the current server and search for the specified username in the /etc/passwd file
    ssh $i -T "cat /etc/passwd | grep $USERNAME"
    
    # Check the exit status of the previous command
    if [ $? -eq 0 ]; then
        # If the username is found, append the server's IP to the success list
        echo $i >> successList.txt
    else
        # If the username is not found, append the server's IP to the failed list
        echo $i >> failedList.txt
    fi
done

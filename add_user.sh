#!/bin/bash
# Creation Date: January 4th 2022
# Description: This script adds a new user to several servers. It requires a list of IPs and a 'Jump' Server that can already connect to the IPs in the list.

# Function to display script usage
usage () {
    echo "$0 usage: [ -i | --interactive ] [ -u | --user USERNAME ] [ -p | --password PASSWORD ] [ -l | --list PATH_TO_SERVER_LIST ] [ -h | --help ]"
}

# Check if any command-line arguments are provided
if [[ $# -gt 0 ]]; then
    # Parse command-line arguments
    while [ -n $1 ]; do
        case $1 in
            --interactive | -i)
                echo "Interactive mode"
                exit 0
                ;;
            -u | --user)
                shift
                NEW_USERNAME=$1
                echo "NEW_USERNAME=$1"
                ;;
            -p | --password)
                shift
                NEW_PASSWORD=$1
                echo "NEW_PASSWORD=$1"
                ;;
            -l | --list)
                shift
                if [[ -e $1 ]]; then
                    SERVERS=$1
                fi
                echo "SERVERS=$1"
                ;;
            -h | --help)
                usage
                ;;
            -*)
                echo "$0 : Illegal option $1 supplied" >&2
                exit 1
                ;;
        esac
        shift
        if [ $# -eq 0 ]; then
            break
        fi
    done
else
    usage
    exit 0
fi

# Loop through each server in the list
for i in $(cat $SERVERS) ; do

    # Check SSH connectivity to the current server
    ssh -o PasswordAuthentication=no -T $i exit &> /dev/null

    # If SSH connection is successful
    if [ $? -eq 0 ]; then

        # Check if the user already exists on the server
        if ssh $i id -u "$NEW_USERNAME" >/dev/null 2>&1; then
            # Inform that the user already exists on the server
            echo "User already exists on $i" | tee -a output.txt
            # Change the password and update user's password aging information
            ssh $i "echo $NEW_PASSWORD | passwd $NEW_USERNAME --stdin && chage -m 0 -M 99999 -I -1 -E -1 $NEW_USERNAME " &> /dev/null

        else
            # Create the new user with specified details and update password aging information
            ssh $i "useradd -m -s /bin/bash -c 'Some User' -G wheel $NEW_USERNAME && echo $NEW_PASSWORD | passwd $NEW_USERNAME --stdin && chage -m 0 -M 99999 -I -1 -E -1 $NEW_USERNAME " &> /dev/null
            # Inform that the user has been successfully created on the server
            echo "User successfully created on $i" | tee -a output.txt
        fi

    else
        # Inform that SSH connection to the server requires a password
        echo "Server $i requires a password" | tee -a output.txt
    fi

done

# Exit the script
exit

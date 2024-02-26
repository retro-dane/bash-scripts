#! /bin/bash

## This script works in conjunction with the update_resolv.sh It will loop through a list of servers given to it in the form of a file and 
## update their resolv.conf as needed.
SERVERS=servers.txt

for i in $(cat $SERVERS) ; do
 ssh -T $i < update_resolv.sh
done



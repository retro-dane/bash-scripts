#! /bin/bash
## This script  will  update the current records inside your /etc/resolv.conf

FILE=/etc/resolve.conf
DECOMDNS=list_of_old_nameservers.txt
NEWDNS=list_of_new_nameservers.txt
COUNT= wc -l list_of_old_nameservers.txt

## Searches for all old name servers and comments them out using a hashtag
for i in $(cat DECOMDNS); do 
    grep $i /etc/resolv.conf;
    if  [ $? -eq 0 ]; then
        sed 's/"$i"/#"$i"/' $FILE
    fi
done

## appends all the new name servers to the  top of the list
for i in $(cat NEWDNS); do 
    grep $i /etc/resolv.conf;
    LINE=cat -n /etc/resolv.conf | grep -m1 "nameserver" | awk '{print $1}'
    if  [ $? -eq 0 ]; then
        sed '$LINE $i ' $FILE
    fi
done


#! /bin/bash
## Script takes a list of server ip's and restarts them. 
## **************DISCLAIMER************** This script has to run from a server that has keyless to all the other servers in the list**************DISCLAIMER**************
SERVERLIST=servers.txt
OUTPUTFILE=output.txt

for x in $(cat $SERVERLIST ); do {
ssh $i "echo shutdown -r now" &> /dev/null
if [$? -ne 0] then 
    echo "Server not restarted" >> $OUTPUTFILE
else
    echo "Restart Succesful" >> $OUTPTFILE
}

#!/bin/bash

#vars
AZFILE=~/.azfile
AZFILEDEST=/etc/
USER=$(whoami)
SSHSVCKEY=~/.ssh/azfile_rsa

docker -H 172.16.0.5:2375 info | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | while read -r IP ; do
    if ! ssh -i $SSHSVCKEY -n $USER@$IP 'cat /mnt/persistent/healthcheck'; 
  then 
    echo "Connection or remote command on $IP failed";
  fi
done
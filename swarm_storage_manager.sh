#!/bin/bash

#vars
AZFILE=~/.azfile
AZFILEDEST=/etc/
USER=$(whoami)
STORAGESCRIPT=~/mount_persistent_storage.sh
SSHSVCKEY=~/.ssh/azfile_rsa


#Create azfile cifs credentials first
if [ ! -f $AZFILE ]; then
    echo [NOTICE] .azfile not found.
	echo Enter the azure cifs username:
    read CIFSUSER
    clear
    echo Enter the azure cifs password:
    read CIFSPASS
    clear
    echo -e "username=$CIFSUSER\npassword=$CIFSPASS" > $AZFILE
    chmod 600 $AZFILE
	echo [NOTICE] $AZFILE created.
else
	echo [INFO] $AZFILE found
fi

#check for SSH service account key
if [ ! -f $SSHSVCKEY ]; then
	echo [NOTICE] Creating $SVCUSER SSH key.
	echo [NOTICE] Do not enter a password for this key.
	ssh-keygen -t rsa -b 4096 -f $SSHSVCKEY -C "Azure File Persistent Storage"
	chmod 600 $SSHSVCKEY
	chmod 600 $SSHSVCKEY.pub
	#create service account on all agents and push public keys for host-to-host connectivity
	docker -H 172.16.0.5:2375 info | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | while read -r IP ; do
		echo [INFO] Processing swarm agent $IP
		echo [NOTICE] Adding $SVCUSER public key.
		cat $SSHSVCKEY.pub | ssh $USER@$IP "sudo mkdir -p ~/.ssh && sudo cat >> ~/.ssh/authorized_keys"
	done
else
	echo [INFO] $SVCUSER SSH key exists.
fi

#execute storage mount on agents
docker -H 172.16.0.5:2375 info | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | while read -r IP ; do
    echo "[INFO] Processing swarm agent $IP"
	echo [NOTICE] Copying persistent storage script files.
    scp -i $SSHSVCKEY $STORAGESCRIPT $AZFILE $USER@$IP:~/
	echo [NOTICE] Mounting storage.
    ssh -i $SSHSVCKEY $USER@$IP -n sudo sh $STORAGESCRIPT
    echo "[INFO] Agent $IP completed."
done
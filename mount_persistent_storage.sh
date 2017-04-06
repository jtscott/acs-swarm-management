#!/bin/bash

#vars
STORAGEENDPOINT=//yourafs.file.core.windows.net/yourshare
PERSISTMNT=/mnt/persistent
AZFILE=~/.azfile

#Mount the file system
if [ ! -d $PERSISTMNT ]; then
	echo [INFO] $PERSISTMNT directory not found.
	mkdir $PERSISTMNT
	echo [NOTICE] $PERSISTMNT created.
else
	echo [INFO] $PERSISTMNT found.
fi

if grep -q $STORAGEENDPOINT /etc/fstab; then
    echo [INFO] $STORAGEENDPOINT found in /etc/fstab
	echo [INFO] Mounting persistent storage
	mount -a
else
    echo [NOTICE] fstab entry not found.
	echo "$STORAGEENDPOINT $PERSISTMNT cifs vers=3.0,credentials=$AZFILE,dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab
	echo [NOTICE] Added persistent storage endpoint to /etc/fstab.
	echo [INFO] Mounting persistent storage
	mount -a
fi
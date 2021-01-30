#!/bin/bash -x

#global env variables
. ./envparams.sh

# select which components to install
UX=N
API=N
DS=N

# you can also set the flags using the command line
for var in "$@"
do
	if [ "ux" == "$var" ]; then UX=Y 
	fi
	if [ "api" == "$var" ]; then API=Y 
	fi
	if [ "ds" == "$var" ]; then DS=Y 
	fi
	if [ "all" == "$var" ]; then DS=Y ; API=Y ; UX=Y 
	fi
done

# we uninstall from the frontend to the backend

#uninstall UX
if [ "${UX}" == "Y" ]; then
	. $ROOT/ux/uninstall.sh
fi

#uninstall API
if [ "${API}" == "Y" ]; then
	. $ROOT/api/uninstall.sh
fi


#uninstall datastore
if [ "${DS}" == "Y" ]; then
	. $ROOT/datastore/uninstall.sh
fi

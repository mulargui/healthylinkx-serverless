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
	if [ "UX" == "$var" ]; then UX=Y 
	fi
	if [ "API" == "$var" ]; then API=Y 
	fi
	if [ "DS" == "$var" ]; then DS=Y 
	fi
done

# we install from the backend to the frontend

#install datastore
if [ "${DS}" == "Y" ]; then
	. $ROOT/datastore/install.sh
fi

#install API
if [ "${API}" == "Y" ]; then
	. $ROOT/api/install.sh
fi

#install UX
if [ "${UX}" == "Y" ]; then
	. $ROOT/ux/install.sh
fi

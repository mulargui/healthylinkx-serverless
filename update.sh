#!/bin/bash -x

#global env variables
. ./envparams.sh

# select which components to install
UX=N
API=N

# you can also set the flags using the command line
for var in "$@"
do
	if [ "ux" == "$var" ]; then UX=Y 
	fi
	if [ "api" == "$var" ]; then API=Y 
	fi
	if [ "all" == "$var" ]; then API=Y ; UX=Y 
	fi
done

# we update from the backend to the frontend

# we dont update the datastore - unistall and install again if needed

#update API
if [ "${API}" == "Y" ]; then
	. $ROOT/api/update.sh
fi

#update UX
if [ "${UX}" == "Y" ]; then
	. $ROOT/ux/update.sh
fi

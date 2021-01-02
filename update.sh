#!/bin/bash -x

#global env variables
. ./aws/envparams.sh

# set up the aws cli environment
. ./aws/aws-cli.sh

#update UX
if [ "$1" == "ux" ]; then
	. ./ux/update.sh
fi

#update API
if [ "$1" == "api" ]; then
	. ./api/update.sh
fi

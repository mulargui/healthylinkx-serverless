#!/bin/bash -x

#global env variables
. ./aws/envparams.sh

# set up the aws cli environment
. ./aws/aws-cli.sh

#install UX
if [ "$1" == "ux" ]; then
	. ./ux/install.sh
fi

#install API
if [ "$1" == "api" ]; then
	. ./api/install.sh
fi

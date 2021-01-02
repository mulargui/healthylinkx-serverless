#!/bin/bash -x

#global env variables
. ./aws/envparams.sh

# set up the aws cli environment
. ./aws/aws-cli.sh

#uninstall UX
if [ "$1" == "ux" ]; then
	. ./ux/uninstall.sh
fi

#uninstall API
if [ "$1" == "api" ]; then
	. ./api/uninstall.sh
fi

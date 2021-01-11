#!/bin/bash -x

#global env variables
. ./envparams.sh

# set up the aws cli environment
. $ROOT/.aws/aws-cli.sh

#uninstall UX
if [ "$1" == "ux" ]; then
	. $ROOT/ux/uninstall.sh
fi

#uninstall API
if [ "$1" == "api" ]; then
	. $ROOT/api/uninstall.sh
fi

#uninstall the datastore 
if [ "$1" == "ds" ]; then
	. $ROOT/datastore/uninstall.sh
fi

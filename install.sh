#!/bin/bash -x

#global env variables
. ./envparams.sh

# set up the aws cli environment
. $ROOT/.aws/aws-cli.sh

#install UX
if [ "$1" == "ux" ]; then
	. $ROOT/ux/install.sh
fi

#install API
if [ "$1" == "api" ]; then
	. $ROOT/api/install.sh
fi

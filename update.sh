#!/bin/bash -x

#global env variables
. ./envparams.sh

# set up the aws cli environment
. $ROOT/.aws/aws-cli.sh

#update UX
if [ "$1" == "ux" ]; then
	. $ROOT/ux/update.sh
fi

#update API
if [ "$1" == "api" ]; then
	. $ROOT/api/update.sh
fi

#!/bin/bash -x

#where are our files
export ROOT=/vagrant/healthylinkx-serverless

# set up the aws cli environment
. ./aws/aws-cli.sh
. ./aws/envparams.sh

#uninstall UX
if [ "$1" == "ux" ]; then
	. ./ux/uninstall.sh
fi

#uninstall API
if [ "$1" == "api" ]; then
	. ./api/uninstall.sh
fi

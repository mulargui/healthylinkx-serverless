#!/bin/bash -x

#where are our files
export ROOT=/vagrant/healthylinkx-serverless

# set up the aws cli environment
. ./aws/aws-cli.sh
. ./aws/envparams.sh

#update UX
if [ "$1" == "ux" ]; then
	. ./ux/update.sh
fi

#update API
if [ "$1" == "api" ]; then
	. ./api/update.sh
fi

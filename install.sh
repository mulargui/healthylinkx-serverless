#!/bin/bash -x

#where are our files
export ROOT=/vagrant/healthylinkx-serverless

# set up the aws cli environment
. ./aws/aws-cli.sh
. ./aws/envparams.sh

#install UX
if [ "$1" == "ux" ]; then
	. ./ux/install.sh
fi

#install API
if [ "$1" == "api" ]; then
	. ./api/install.sh
fi

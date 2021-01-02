#!/bin/bash -x

#global env variables
. ./aws/envparams.sh

# set up the aws cli environment
. ./aws/aws-cli.sh

#run a command
if [ "$1" == "lambda" ]; then
	aws lambda invoke --function-name taxonomy /fs/out --log-type Tail --query 'LogResult' |  base64 -d
	cat out
	rm out
fi

if [ "$1" == "whoami" ]; then
	aws sts get-caller-identity
fi

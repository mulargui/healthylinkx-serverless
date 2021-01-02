#!/bin/bash -x

#where are our files
export ROOT=/vagrant/healthylinkx-serverless

# set up the aws cli environment
. ./aws/aws-cli.sh
. ./aws/envparams.sh

#run a command
if [ "$1" == "lambda" ]; then
	aws lambda invoke --function-name taxonomy /fs/out --log-type Tail --query 'LogResult' |  base64 -d
	cat out
	rm out
fi
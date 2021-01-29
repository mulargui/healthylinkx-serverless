#!/bin/bash -x

#global env variables
. ./envparams.sh

# set up the aws cli environment
. $ROOT/.aws/aws-cli.sh

#run a command
if [ "$1" == "lambda" ]; then
	aws lambda invoke --function-name taxonomy $ROOT/out --log-type Tail --query 'LogResult' |  base64 -d
	cat $ROOT/out
	rm $ROOT/out
fi


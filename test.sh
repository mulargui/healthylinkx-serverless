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

if [ "$1" == "whoami" ]; then
	aws sts get-caller-identity
fi

if [ "$1" == "sg" ]; then
	aws ec2 create-security-group --group-name DBSecGroup --description "MySQL Sec Group"
fi

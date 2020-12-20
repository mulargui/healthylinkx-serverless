#!/bin/bash -x

#if you don't have zip installed
#sudo apt install zip

#create a IAM role under which the lambda will run
aws iam create-role --role-name healthylinkx-lambda --assume-role-policy-document '{"Version": "2012-10-17","Statement": [{ "Effect": "Allow", "Principal": {"Service": "lambda.amazonaws.com"}, "Action": "sts:AssumeRole"}]}'

#creating a lambda with the code
zip taxonomy.zip $ROOT/api/src/taxonomy.js
aws lambda create-function \
	--function-name taxonomy \
	--runtime nodejs12.x \
	--role arn:aws:iam::1234:role/healthylinkx-lambda \
	--zip-file fileb:///fs/taxonomy.zip
rm taxonomy.zip

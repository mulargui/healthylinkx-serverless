#!/bin/bash -x

#delete the lambda function
aws lambda delete-function \
	--function-name taxonomy
	
#delete the IAM role used by the lambda
aws iam delete-role --role-name healthylinkx-lambda 
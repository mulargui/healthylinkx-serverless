#!/bin/bash -x

#delete the api gateway
APIID=$(aws apigateway get-rest-apis --query "items[?name==\`healthylinkx\`].id")
aws apigateway delete-rest-api --rest-api-id $APIID

#delete the IAM role used by the apigateway
aws iam delete-role --role-name healthylinkx-apigateway 

#delete the lambda functions
aws lambda delete-function --function-name taxonomy
aws lambda delete-function --function-name providers
	
#delete the IAM role used by the lambda
aws iam delete-role --role-name healthylinkx-lambda 
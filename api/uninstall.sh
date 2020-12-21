#!/bin/bash -x

#delete the api gateway
APINAME=healthylinkx
APIID=$(aws apigateway get-rest-apis --query "items[?name==\`${APINAME}\`].id")
aws apigateway delete-rest-api --rest-api-id $APIID

#delete the IAM role used by the apigateway
aws iam delete-role --role-name healthylinkx-apigateway 

#delete the lambda function
aws lambda delete-function --function-name taxonomy
	
#delete the IAM role used by the lambda
aws iam delete-role --role-name healthylinkx-lambda 
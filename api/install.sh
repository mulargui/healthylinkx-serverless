#!/bin/bash -x

#if you don't have zip installed
#sudo apt install zip

#create a IAM role under which the lambda will run
aws iam create-role --role-name healthylinkx-lambda --assume-role-policy-document '{"Version": "2012-10-17","Statement": [{ "Effect": "Allow", "Principal": {"Service": "lambda.amazonaws.com"}, "Action": "sts:AssumeRole"}]}'
#wait a few seconds till the role is created. otherwise there is an error creating the lambda
sleep 10

#creating a lambda with the code
zip -j taxonomy.zip $ROOT/api/src/taxonomy.js
aws lambda create-function \
	--function-name taxonomy \
	--runtime nodejs12.x \
	--handler taxonomy.handler \
	--role arn:aws:iam::$AWS_ACCOUNT_ID:role/healthylinkx-lambda \
	--zip-file fileb:///fs/taxonomy.zip
rm taxonomy.zip

LAMBDAARN=$(aws lambda list-functions --query "Functions[?FunctionName==\`taxonomy\`].FunctionArn")  

#create a IAM role under which the apigateway will access the lambda
aws iam create-role --role-name healthylinkx-apigateway --assume-role-policy-document '{"Version": "2012-10-17","Statement": [{ "Effect": "Allow", "Principal": {"Service": "apigateway.amazonaws.com"}, "Action": "sts:AssumeRole"}]}'
#wait a few seconds till the role is created. otherwise there is an error creating the lambda
sleep 10

#create the REST api
APINAME=healthylinkx
aws apigateway create-rest-api --name $APINAME 
APIID=$(aws apigateway get-rest-apis --query "items[?name==\`${APINAME}\`].id")

PARENTRESOURCEID=$(aws apigateway get-resources --rest-api-id ${APIID} --query "items[?path=='/'].id")
aws apigateway create-resource --rest-api-id $APIID --parent-id $PARENTRESOURCEID --path-part taxonomy
RESOURCEID=$(aws apigateway get-resources --rest-api-id ${APIID} --query "items[?path=='/taxonomy'].id")

aws apigateway put-method --rest-api-id $APIID --resource-id $RESOURCEID --http-method GET --authorization-type "NONE"
aws apigateway put-method-response --rest-api-id $APIID --resource-id $RESOURCEID --http-method GET --status-code 200

aws apigateway put-integration --rest-api-id $APIID --resource-id $RESOURCEID \
    --http-method GET --type AWS_PROXY --integration-http-method POST \
    --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${LAMBDAARN}/invocations \
    --credentials arn:aws:iam::$AWS_ACCOUNT_ID:role/healthylinkx-apigateway
aws apigateway create-deployment --rest-api-id $APIID --stage-name prod

# URL of the api
# https://healthylinkx.execute-api.us-east-1.amazonaws.com

exit 1

aws lambda add-permission --function-name LambdaFunctionOverHttps \
	--statement-id apigateway-test-2 --action lambda:InvokeFunction \
	--principal apigateway.amazonaws.com \
	--source-arn "arn:aws:execute-api:$REGION:$AWS_ACCOUNT_ID:$API/*/POST/DynamoDBManager"
{
    "Statement": "{\"Sid\":\"apigateway-test-2\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"apigateway.amazonaws.com\"},\"Action\":\"lambda:InvokeFunction\",\"Resource\":\"arn:aws:lambda:us-east-2:123456789012:function:LambdaFunctionOverHttps\",\"Condition\":{\"ArnLike\":{\"AWS:SourceArn\":\"arn:aws:execute-api:us-east-2:123456789012:mnh1yprki7/*/POST/DynamoDBManager\"}}}"
}

aws lambda add-permission --function-name LambdaFunctionOverHttps \
--statement-id apigateway-prod-2 --action lambda:InvokeFunction \
--principal apigateway.amazonaws.com \
--source-arn "arn:aws:execute-api:$REGION:$ACCOUNT:$API/prod/POST/DynamoDBManager"
{
    "Statement": "{\"Sid\":\"apigateway-prod-2\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"apigateway.amazonaws.com\"},\"Action\":\"lambda:InvokeFunction\",\"Resource\":\"arn:aws:lambda:us-east-2:123456789012:function:LambdaFunctionOverHttps\",\"Condition\":{\"ArnLike\":{\"AWS:SourceArn\":\"arn:aws:execute-api:us-east-2:123456789012:mnh1yprki7/prod/POST/DynamoDBManager\"}}}"
}

#!/bin/bash -x

#if you don't have zip installed
#sudo apt install zip

# create contants.js with env values
ENDPOINT=$(aws rds describe-db-instances --db-instance-identifier healthylinkx-db --query "DBInstances[*].Endpoint.Address")
sed "s/MySQLDB/$ENDPOINT/" $ROOT/api/src/constants.template.js > $ROOT/api/src/constants.js
sed -i "s/YYYYYYYYYY/$DBUSER/" $ROOT/api/src/constants.js
sed -i "s/XXXXXXXXXX/$DBPWD/" $ROOT/api/src/constants.js

# install node dependencies
(cd $ROOT/api/src; npm install url dns mysql wait.for)

#create a IAM role under which the lambda will run
aws iam create-role --role-name healthylinkx-lambda --assume-role-policy-document '{"Version": "2012-10-17","Statement": [{ "Effect": "Allow", "Principal": {"Service": "lambda.amazonaws.com"}, "Action": "sts:AssumeRole"}]}'
#wait a few seconds till the role is created. otherwise there is an error creating the lambda
sleep 10

#creating a lambda with the code
(cd $ROOT/api/src; zip -r taxonomy.zip taxonomy.js constants.js package-lock.json node_modules)
aws lambda create-function \
	--function-name taxonomy \
	--runtime nodejs12.x \
	--handler taxonomy.handler \
	--role arn:aws:iam::$AWS_ACCOUNT_ID:role/healthylinkx-lambda \
	--zip-file fileb://$ROOT/api/src/taxonomy.zip

# cleanup
rm $ROOT/api/src/taxonomy.zip
rm $ROOT/api/src/package-lock.json
rm $ROOT/api/src/constants.js
rm -r $ROOT/api/src/node_modules

LAMBDAARN=$(aws lambda list-functions --query "Functions[?FunctionName==\`taxonomy\`].FunctionArn")  

#create a IAM role under which the apigateway will access the lambda
aws iam create-role --role-name healthylinkx-apigateway --assume-role-policy-document '{"Version": "2012-10-17","Statement": [{ "Sid":"", "Effect": "Allow", "Principal": {"Service": "apigateway.amazonaws.com"}, "Action": "sts:AssumeRole"}]}'
#wait a few seconds till the role is created. otherwise there is an error creating the lambda
sleep 10

#create the REST apigateway
aws apigateway create-rest-api --name healthylinkx
APIID=$(aws apigateway get-rest-apis --query "items[?name==\`healthylinkx\`].id")
PARENTRESOURCEID=$(aws apigateway get-resources --rest-api-id ${APIID} --query "items[?path=='/'].id")

#create the resource (taxonomy)
aws apigateway create-resource --rest-api-id $APIID --parent-id $PARENTRESOURCEID --path-part taxonomy
RESOURCEID=$(aws apigateway get-resources --rest-api-id ${APIID} --query "items[?path=='/taxonomy'].id")

#create the method (GET)
aws apigateway put-method --rest-api-id $APIID --resource-id $RESOURCEID --http-method GET --authorization-type NONE

#link the lambda to the method
aws apigateway put-integration --rest-api-id $APIID --resource-id $RESOURCEID \
    --http-method GET --type AWS_PROXY --integration-http-method POST \
    --uri arn:aws:apigateway:$AWS_REGION:lambda:path/2015-03-31/functions/${LAMBDAARN}/invocations

#enable CORS
#aws apigatewayv2 update-api --api-id $APIID --cors-configuration AllowOrigins="*"

#deploy all
aws apigateway create-deployment --rest-api-id $APIID --stage-name prod

#allow apigateway to call the lambda
aws lambda add-permission --function-name taxonomy --action lambda:InvokeFunction --statement-id api-lambda --principal apigateway.amazonaws.com

# URL of the api
echo https://$APIID.execute-api.$AWS_REGION.amazonaws.com/prod/taxonomy

#!/bin/bash -x

#if you don't have zip installed
#sudo apt install zip

#create a IAM role under which the lambdas will run
aws iam create-role --role-name healthylinkx-lambda --assume-role-policy-document '{"Version": "2012-10-17","Statement": [{ "Effect": "Allow", "Principal": {"Service": "lambda.amazonaws.com"}, "Action": "sts:AssumeRole"}]}'
#wait a few seconds till the role is created. otherwise there is an error creating the lambda
sleep 10

# create contants.js with env values
ENDPOINT=$(aws rds describe-db-instances --db-instance-identifier healthylinkx-db --query "DBInstances[*].Endpoint.Address")
sed "s/ENDPOINT/$ENDPOINT/" $ROOT/api/src/constants.template.js > $ROOT/api/src/constants.js
sed -i "s/DBUSER/$DBUSER/" $ROOT/api/src/constants.js
sed -i "s/DBPWD/$DBPWD/" $ROOT/api/src/constants.js
sed -i "s/ZIPCODEAPI/$ZIPCODEAPI/" $ROOT/api/src/constants.js
sed -i "s/ZIPCODETOKEN/$ZIPCODETOKEN/" $ROOT/api/src/constants.js

# install node dependencies
(cd $ROOT/api/src; npm install mysql2 http)

#package the taxonomy code
(cd $ROOT/api/src; zip -r taxonomy.zip taxonomy.js constants.js package-lock.json node_modules)

#creating a taxonomy lambda with the package
aws lambda create-function \
	--function-name taxonomy \
	--runtime nodejs12.x \
	--handler taxonomy.handler \
	--role arn:aws:iam::$AWS_ACCOUNT_ID:role/healthylinkx-lambda \
	--zip-file fileb://$ROOT/api/src/taxonomy.zip

#package the providers code
(cd $ROOT/api/src; zip -r providers.zip providers.js constants.js package-lock.json node_modules)

#creating a providers lambda with the package
aws lambda create-function \
	--function-name providers \
	--runtime nodejs12.x \
	--handler providers.handler \
	--role arn:aws:iam::$AWS_ACCOUNT_ID:role/healthylinkx-lambda \
	--zip-file fileb://$ROOT/api/src/providers.zip

#package the shortlist code
(cd $ROOT/api/src; zip -r shortlist.zip shortlist.js constants.js package-lock.json node_modules)

#creating a shortlist lambda with the package
aws lambda create-function \
	--function-name shortlist \
	--runtime nodejs12.x \
	--handler shortlist.handler \
	--role arn:aws:iam::$AWS_ACCOUNT_ID:role/healthylinkx-lambda \
	--zip-file fileb://$ROOT/api/src/shortlist.zip

#package the transaction code
(cd $ROOT/api/src; zip -r transaction.zip transaction.js constants.js package-lock.json node_modules)

#creating a transaction lambda with the package
aws lambda create-function \
	--function-name transaction \
	--runtime nodejs12.x \
	--handler transaction.handler \
	--role arn:aws:iam::$AWS_ACCOUNT_ID:role/healthylinkx-lambda \
	--zip-file fileb://$ROOT/api/src/transaction.zip

# cleanup
rm $ROOT/api/src/*.zip
rm $ROOT/api/src/package-lock.json
rm $ROOT/api/src/constants.js
rm -r $ROOT/api/src/node_modules

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
LAMBDAARN=$(aws lambda list-functions --query "Functions[?FunctionName==\`taxonomy\`].FunctionArn")  
aws apigateway put-integration --rest-api-id $APIID --resource-id $RESOURCEID \
    --http-method GET --type AWS_PROXY --integration-http-method POST \
    --uri arn:aws:apigateway:$AWS_REGION:lambda:path/2015-03-31/functions/${LAMBDAARN}/invocations

#allow apigateway to call the lambda
aws lambda add-permission --function-name taxonomy --action lambda:InvokeFunction --statement-id api-lambda --principal apigateway.amazonaws.com

#create the resource (providers)
aws apigateway create-resource --rest-api-id $APIID --parent-id $PARENTRESOURCEID --path-part providers
RESOURCEID=$(aws apigateway get-resources --rest-api-id ${APIID} --query "items[?path=='/providers'].id")

#create the method (GET)
aws apigateway put-method --rest-api-id $APIID --resource-id $RESOURCEID --http-method GET --authorization-type NONE

#link the lambda to the method
LAMBDAARN=$(aws lambda list-functions --query "Functions[?FunctionName==\`providers\`].FunctionArn")  
aws apigateway put-integration --rest-api-id $APIID --resource-id $RESOURCEID \
    --http-method GET --type AWS_PROXY --integration-http-method POST \
    --uri arn:aws:apigateway:$AWS_REGION:lambda:path/2015-03-31/functions/${LAMBDAARN}/invocations

#allow apigateway to call the lambda
aws lambda add-permission --function-name providers --action lambda:InvokeFunction --statement-id api-lambda --principal apigateway.amazonaws.com

#create the resource (shortlist)
aws apigateway create-resource --rest-api-id $APIID --parent-id $PARENTRESOURCEID --path-part shortlist
RESOURCEID=$(aws apigateway get-resources --rest-api-id ${APIID} --query "items[?path=='/shortlist'].id")

#create the method (GET)
aws apigateway put-method --rest-api-id $APIID --resource-id $RESOURCEID --http-method GET --authorization-type NONE

#link the lambda to the method
LAMBDAARN=$(aws lambda list-functions --query "Functions[?FunctionName==\`shortlist\`].FunctionArn")  
aws apigateway put-integration --rest-api-id $APIID --resource-id $RESOURCEID \
    --http-method GET --type AWS_PROXY --integration-http-method POST \
    --uri arn:aws:apigateway:$AWS_REGION:lambda:path/2015-03-31/functions/${LAMBDAARN}/invocations

#allow apigateway to call the lambda
aws lambda add-permission --function-name shortlist --action lambda:InvokeFunction --statement-id api-lambda --principal apigateway.amazonaws.com

#create the resource (transaction)
aws apigateway create-resource --rest-api-id $APIID --parent-id $PARENTRESOURCEID --path-part transaction
RESOURCEID=$(aws apigateway get-resources --rest-api-id ${APIID} --query "items[?path=='/transaction'].id")

#create the method (GET)
aws apigateway put-method --rest-api-id $APIID --resource-id $RESOURCEID --http-method GET --authorization-type NONE

#link the lambda to the method
LAMBDAARN=$(aws lambda list-functions --query "Functions[?FunctionName==\`transaction\`].FunctionArn")  
aws apigateway put-integration --rest-api-id $APIID --resource-id $RESOURCEID \
    --http-method GET --type AWS_PROXY --integration-http-method POST \
    --uri arn:aws:apigateway:$AWS_REGION:lambda:path/2015-03-31/functions/${LAMBDAARN}/invocations

#allow apigateway to call the lambda
aws lambda add-permission --function-name transaction --action lambda:InvokeFunction --statement-id api-lambda --principal apigateway.amazonaws.com

#deploy all
aws apigateway create-deployment --rest-api-id $APIID --stage-name prod

# URL of the api
echo https://$APIID.execute-api.$AWS_REGION.amazonaws.com/prod/taxonomy

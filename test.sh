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

# create contants.js with env values
ENDPOINT=$(aws rds describe-db-instances --db-instance-identifier healthylinkx-db --query "DBInstances[*].Endpoint.Address")
sed "s/MySQLDB/$ENDPOINT/" $ROOT/api/src/constants.template.js > $ROOT/api/src/constants.js
sed "s/YYYYYYYYYY/$DBUSER/" $ROOT/api/src/constants.js > $ROOT/api/src/constants.js
sed "s/XXXXXXXXXX/$DBPWD/" $ROOT/api/src/constants.js > $ROOT/api/src/constants.js

# install node dependencies
npm install –prefix=$ROOT/api/src mysql wait.for

#creating a lambda with the code
zip -j taxonomy.zip $ROOT/api/src/taxonomy.js $ROOT/api/src/constants.js $ROOT/api/src/node_modules/*


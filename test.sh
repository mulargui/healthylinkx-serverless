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

rm taxonomy.zip
rm -r $ROOT/api/src/node_modules
rm $ROOT/api/src/package-lock.json


# install node dependencies
npm install mysql wait.for
mv node_modules $ROOT/api/src
mv package-lock.json $ROOT/api/src

#creating a lambda with the code
zip -r -j taxonomy.zip $ROOT/api/src/taxonomy.js $ROOT/api/src/constants.js $ROOT/api/src/package-lock.json $ROOT/api/src/node_modules

  
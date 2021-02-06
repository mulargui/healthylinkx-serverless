#!/bin/bash -x

# create contants.js with env values
ENDPOINT=$(aws rds describe-db-instances --db-instance-identifier healthylinkx-db --query "DBInstances[*].Endpoint.Address")
sed "s/ENDPOINT/$ENDPOINT/" $ROOT/api/src/constants.template.js > $ROOT/api/src/constants.js
sed -i "s/DBUSER/$DBUSER/" $ROOT/api/src/constants.js
sed -i "s/DBPWD/$DBPWD/" $ROOT/api/src/constants.js
sed -i "s/ZIPCODEAPI/$ZIPCODEAPI/" $ROOT/api/src/constants.js
sed -i "s/ZIPCODETOKEN/$ZIPCODETOKEN/" $ROOT/api/src/constants.js

# install node dependencies
(cd $ROOT/api/src; npm install mysql2 axios)

#package the code (taxonomy)
(cd $ROOT/api/src; zip -r taxonomy.zip taxonomy.js constants.js package-lock.json node_modules)

#updating the lambda code
aws lambda update-function-code --function-name taxonomy --zip-file fileb://$ROOT/api/src/taxonomy.zip

#package the code (providers)
(cd $ROOT/api/src; zip -r providers.zip providers.js constants.js package-lock.json node_modules)

#updating the lambda code
aws lambda update-function-code --function-name providers --zip-file fileb://$ROOT/api/src/providers.zip

#package the code (shortlist)
(cd $ROOT/api/src; zip -r shortlist.zip shortlist.js constants.js package-lock.json node_modules)

#updating the lambda code
aws lambda update-function-code --function-name shortlist --zip-file fileb://$ROOT/api/src/shortlist.zip

#package the code (transaction)
(cd $ROOT/api/src; zip -r transaction.zip transaction.js constants.js package-lock.json node_modules)

#updating the lambda code
aws lambda update-function-code --function-name transaction --zip-file fileb://$ROOT/api/src/transaction.zip

# cleanup
rm $ROOT/api/src/*.zip
rm $ROOT/api/src/package-lock.json
rm $ROOT/api/src/constants.js
rm -r $ROOT/api/src/node_modules

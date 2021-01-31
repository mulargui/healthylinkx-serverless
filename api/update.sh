#!/bin/bash -x

# create contants.js with env values
ENDPOINT=$(aws rds describe-db-instances --db-instance-identifier healthylinkx-db --query "DBInstances[*].Endpoint.Address")
sed "s/MySQLDB/$ENDPOINT/" $ROOT/api/src/constants.template.js > $ROOT/api/src/constants.js
sed -i "s/YYYYYYYYYY/$DBUSER/" $ROOT/api/src/constants.js
sed -i "s/XXXXXXXXXX/$DBPWD/" $ROOT/api/src/constants.js

# install node dependencies
(cd $ROOT/api/src; npm install mysql2 http)

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

# cleanup
rm $ROOT/api/src/*.zip
rm $ROOT/api/src/package-lock.json
rm $ROOT/api/src/constants.js
rm -r $ROOT/api/src/node_modules

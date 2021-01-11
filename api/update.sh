#!/bin/bash -x

#updating the lambda code
zip -j taxonomy.zip $ROOT/api/src/taxonomy.js
aws lambda update-function-code --function-name taxonomy --zip-file fileb://$ROOT/taxonomy.zip
rm taxonomy.zip

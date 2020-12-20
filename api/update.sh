#!/bin/bash -x

#updating the lambda code
zip taxonomy.zip $ROOT/api/src/taxonomy.js
aws lambda update-function-code --function-name taxonomy --zip-file fileb:///fs/taxonomy.zip
rm taxonomy.zip

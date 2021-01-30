#!/bin/bash -x

#include the API URL in the javascript code
APIID=$(aws apigateway get-rest-apis --query "items[?name==\`healthylinkx\`].id")
sed "s/APIID/$APIID/" $ROOT/ux/src/js/constants.template.js > $ROOT/ux/src/js/constants.js

#sync'ing files in the S3 bucket
aws s3 sync $ROOT/ux/src s3://healthylinkx --acl public-read

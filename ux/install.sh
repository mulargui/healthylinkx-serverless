#!/bin/bash -x

#installing UX using S3
aws s3api create-bucket --bucket healthylinkx
aws2 s3 sync /src s3://healthylinkx --acl public-read
aws s3 website s3://healthylinkx/ --index-document index.html

#this is the URL of the bucket
# http://healthylinkx.s3-website-us-east-1.amazonaws.com/
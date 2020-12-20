#!/bin/bash -x

#sync'ing files in the S3 bucket
aws2 s3 sync /src s3://healthylinkx --acl public-read

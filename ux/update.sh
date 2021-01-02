#!/bin/bash -x

#sync'ing files in the S3 bucket
aws s3 sync $ROOT/ux/src s3://healthylinkx --acl public-read

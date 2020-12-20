#!/bin/bash -x

#provision UX
echo "do nothing!"

#list buckets
aws s3api list-buckets --query "Buckets[].Name"

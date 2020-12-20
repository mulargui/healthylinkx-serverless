#!/bin/bash -x

#deleting S3 bucket
aws s3 rm s3://healthylinkx --recursive
aws s3api delete-bucket --bucket healthylinkx

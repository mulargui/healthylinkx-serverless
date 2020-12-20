#!/bin/bash -x

#where are our files
export ROOT=/vagrant/healthylinkx-serverless

# set up the aws cli environment
. ./aws/aws-cli.sh

#uninstall UX
. ./ux/uninstall.sh

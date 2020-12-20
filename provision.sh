#!/bin/bash -x

# Load AWS secrets and other config
. ./aws-config.sh

#provision UX
. ./ux/provision.sh

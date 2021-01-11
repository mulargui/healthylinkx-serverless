#!/bin/bash -x

#delete aurora serverless instance
aws rds delete-db-cluster --db-cluster-identifier healthylinkx-cluster \
	--skip-final-snapshot 
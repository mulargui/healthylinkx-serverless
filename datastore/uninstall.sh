#!/bin/bash -x

#delete mysql instance
aws rds delete-db-instance --db-cluster-identifier healthylinkx-db \
	--skip-final-snapshot \
	--delete-automated-backups
#!/bin/bash -x

#delete mysql instance
aws rds delete-db-instance --db-instance-identifier healthylinkx-db \
	--skip-final-snapshot \
	--delete-automated-backups

#wait till the instance is deleted
aws rds wait db-instance-deleted \
    --db-instance-identifier healthylinkx-db

# delete the security group	
aws ec2 delete-security-group --group-name DBSecGroup

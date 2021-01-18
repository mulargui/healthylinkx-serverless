#!/bin/bash -x

#create mysql instance
aws rds create-db-instance \
	--db-instance-identifier healthylinkx-db \
	--db-name healthylinkx \
	--allocated-storage 20 \
	--db-instance-class db.t2.micro \
	--engine mysql \
	--master-username $DBUSER \
	--master-user-password $DBPWD \
	--backup-retention-period 0 \
	--publicly-accessible
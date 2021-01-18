#!/bin/bash -x

# In order to have public access to the DB outside the VPC I added an inbound rule 
# to the security group of the VPC (default in my case)
# protocol:TCP, Port:3306, Source: Anywhere (0.0.0.0/0)

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
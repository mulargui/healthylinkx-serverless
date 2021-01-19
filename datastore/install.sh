#!/bin/bash -x

# In order to have public access to the DB
# we need to create a security group (aka firewall)with an inbound rule 
# protocol:TCP, Port:3306, Source: Anywhere (0.0.0.0/0)
aws ec2 create-security-group --group-name DBSecGroup --description "MySQL Sec Group"
aws ec2 authorize-security-group-ingress \
	--group-name DBSecGroup \
	--protocol tcp \
	--port 3306 \
	--cidr 0.0.0.0/0

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
	--vpc-security-group-ids <value> \
	--publicly-accessible
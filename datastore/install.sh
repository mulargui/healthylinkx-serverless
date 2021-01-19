#!/bin/bash -x

#wait till the instance is provisioned
aws rds wait db-instance-available \
    --db-instance-identifier healthylinkx-db
echo "MySQL provisioned!"

#RDS instance endpoint
ENDPOINT= $(aws rds describe-db-instances --db-instance-identifier healthylinkx-db --query "DBInstances[*].Endpoint.Address")
	
#unzip de data file
unzip -o $ROOT/datastore/src/healthylinkxdump.sql -d $ROOT/datastore/src

#load the data (and schema) into the database
mysql -h $ENDPOINT -u $DBUSER -p$DBPWD healthylinkx < $ROOT/datastore/src/healthylinkxdump.sql

#delete the unzipped file
#rm $ROOT/datastore/src/healthylinkxdump.sql

exit



# In order to have public access to the DB
# we need to create a security group (aka firewall)with an inbound rule 
# protocol:TCP, Port:3306, Source: Anywhere (0.0.0.0/0)
aws ec2 create-security-group --group-name DBSecGroup --description "MySQL Sec Group"
aws ec2 authorize-security-group-ingress \
	--group-name DBSecGroup \
	--protocol tcp \
	--port 3306 \
	--cidr 0.0.0.0/0

SGID=$(aws ec2 describe-security-groups --group-names DBSecGroup --query 'SecurityGroups[*].[GroupId]')

#create mysql instance (and database)
aws rds create-db-instance \
	--db-instance-identifier healthylinkx-db \
	--db-name healthylinkx \
	--allocated-storage 20 \
	--db-instance-class db.t2.micro \
	--engine mysql \
	--master-username $DBUSER \
	--master-user-password $DBPWD \
	--backup-retention-period 0 \
	--vpc-security-group-ids $SGID \
	--publicly-accessible

#wait till the instance is provisioned
aws rds wait db-instance-available \
    --db-instance-identifier healthylinkx-db

#RDS instance endpoint
ENDPOINT= $(aws rds describe-db-instances --db-instance-identifier healthylinkx-db --query "DBInstances[*].Endpoint.Address")
	
#unzip de data file
unzip -o $ROOT/datastore/src/healthylinkxdump.sql -d $ROOT/datastore/src

#load the data (and schema) into the database
mysql -h $ENDPOINT -u $DBUSER -p$DBPWD healthylinkx < $ROOT/datastore/src/healthylinkxdump.sql

#delete the unzipped file
rm $ROOT/datastore/src/healthylinkxdump.sql
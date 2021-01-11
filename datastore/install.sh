#!/bin/bash -x

#create aurora serverless instance
aws rds create-db-cluster --db-cluster-identifier healthylinkx-cluster \
	--engine aurora --engine-mode serverless \
	--scaling-configuration MinCapacity=1,MaxCapacity=1,SecondsUntilAutoPause=300,AutoPause=true \
	--master-username $DBUSER --master-user-password $DBPWD

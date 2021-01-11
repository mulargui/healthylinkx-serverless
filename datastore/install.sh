#!/bin/bash -x

#create aurora serverless instance
aws rds create-db-cluster --db-cluster-identifier healthylinkx-cluster \
	--engine aurora --engine-mode serverless 
	#--scaling-configuration MinCapacity=4,MaxCapacity=32,SecondsUntilAutoPause=1000,AutoPause=true \
	--master-username $DBUSER --master-user-password $DBPWD

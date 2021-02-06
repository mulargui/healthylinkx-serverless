# healthylinkx-serverless
Healthylinkx is a 3 tiers app: ux, api and datastore. Implementation of Healthylinkx using AWS serverless resources (S3, API Gateway, Lambda, RDS MySQL, CloudShell)

Based on the following repos (look at the documentation in each of them)
UX https://github.com/mulargui/healthylinkx-ux
API https://github.com/mulargui/healthylinkx-api-in-node
Datastore https://github.com/mulargui/healthylinkx-mysql

This app installs in your default VPC. I need to add a little bit more work to the installation scripts 
to create a dedicated VPC.

Directories and files
/ - scripts to install, uninstall and update the whole app
/envparams-template.sh - All the parameters of the app, like AWS secrets...
Fill your data and save it as envparams.sh

The API is implemented as a set of lambdas exposed by an API Gateway
/api - scripts to install, uninstall and update the API Gateway and the Lambdas
/api/src - source code of the lambdas (node js) - one file per lambda

The datastore is a RDS MySql instance
/datastore - scripts to install and uninstall the RDS My SQL instance (no update available)
/datastore/src - dump of the healthylinkx database
Note: Removed the table npidata1 from the original dump file as it was causing errors due its size

The ux is a web app (html+jquery+bootstrap+javascript) hosted in a S3 bucket
/ux - scripts to install, uninstall and update the S3 bucket
/ux/src - the source code of the ux app 



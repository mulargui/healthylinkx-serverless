# healthylinkx-serverless
Implementation of Healthylinkx using AWS serverless resources (S3, API Gateway, Lambda, RDS MySQL, CloudShell)

Based on the following repos (look at the documentation in each of them)
UX interface https://github.com/mulargui/healthylinkx-ux
API https://github.com/mulargui/healthylinkx-api-in-node
Datastore https://github.com/mulargui/healthylinkx-mysql

Notes:
Datastore. Removed the table npidata1 from the dump file as it was causing errors due its size

Directories and files
.aws - AWS Cli configuration files
api - api implementatin (lambdas in node.js)
datastore - database setup
ux - ux implementation
envparams



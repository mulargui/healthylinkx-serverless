# healthylinkx-serverless

Healthylinkx helps you find doctors with the help of your social network. Think of Healthylinkx as a combination of Yelp, Linkedin and Facebook. 

This is an early prototype that combines open data of doctors and specialists from the US Department of Health. It allows you to search for doctors based on location, specialization, genre or name. You can choose up to three doctors in the result list and Healthylinkx (theoretically) will book appointments for you.

Healthylinx is a classic three tiers app: front-end (ux), service API and data store. It also integrates with a third-party API from RedLine13 (https://www.redline13.com) to find zip codes in an area. Healthylinkx creates and runs a container for each tier.

This architecture makes it very adequate to test different technologies and I use it for getting my hands dirty on new stuff. You might need to combine what is in this repo with other repos if you want to build the app end to end. It is like a lego where you can pick and choose different technologies as you see fit. Enjoy!

This repo implements Healthylinkx using AWS serverless resources (S3, API Gateway, Lambda, RDS MySQL, CloudShell)

Based on the following repos (look at the documentation in each of them)  
UX https://github.com/mulargui/healthylinkx-ux  
API https://github.com/mulargui/healthylinkx-api-in-node  
Datastore https://github.com/mulargui/healthylinkx-mysql

This app installs in your default VPC. I need to add a little bit more work to the installation scripts to create a dedicated VPC.

Directories and files  
/ - scripts to install, uninstall and update the whole app  
/envparams-template.sh - All the parameters of the app, like AWS secrets...
Fill your data and save it as envparams.sh

The API is implemented as a set of lambdas exposed by an API Gateway  
/api - scripts to install, uninstall and update the API Gateway and the Lambdas  
/api/src - source code of the lambdas (node js) - one file per lambda  

The datastore is a RDS MySql instance  
/datastore - scripts to install and uninstall the RDS MySQL instance (no update available)  
/datastore/src - dump of the healthylinkx database  
Note: Removed the table npidata1 from the original dump file as it was causing errors due its size  

The ux is a web app (html+jquery+bootstrap+javascript) hosted in a S3 bucket  
/ux - scripts to install, uninstall and update the S3 bucket  
/ux/src - the source code of the ux app 



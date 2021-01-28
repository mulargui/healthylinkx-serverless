var mysql=require("mysql");
var url = require("url");
var constants = require("./constants.js");
var dns = require('dns');
var wait=require('wait.for');

function ServerReply (code, message){
	console.log ('code: ', code , 'message: ', message);

	const response = {
		"statusCode": code,
		"headers": {
			"Access-Control-Allow-Headers": "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
			"Access-Control-Allow-Origin": "*",
			"Access-Control-Allow-Methods": "OPTIONS,GET"
		},
		"body": JSON.stringify(message)
	};
	return response;
}

exports.handler = async (event) => {
	var id = event.queryStringParameters.[id];

 	//check params
 	if(!id) return ServerReply (204, 'no transaction id');
	
	//connect to the DB
	var db = mysql.createConnection({
		host:dbhost,
		user:constants.user,
		password:constants.password,
		database:constants.database
	});

	//retrieve the providers
	var query = "SELECT * FROM transactions WHERE (id = '"+id+"')";
	db.query(query, function(err,results,fields){		
		if (err) return ServerReply (500, 'db.query failed! ' + query);

		if (results.length <= 0) return ServerReply (204, 'no providers for transaction: ' + id);

		//get the providers
		var npi1 = results[0].NPI1;
		var npi2 = results[0].NPI2;
		var npi3 = results[0].NPI3;
	
		//get the details of the providers
		query = "SELECT NPI,Provider_Full_Name,Provider_Full_Street, Provider_Full_City, Provider_Business_Practice_Location_Address_Telephone_Number FROM npidata2 WHERE ((NPI = '"+npi1+"')";
		if(npi2) query += "OR (NPI = '"+npi2+"')";
		if(npi3) query += "OR (NPI = '"+npi3+"')";
		query += ")";

 		db.query(query, function(err,results,fields){		
			if (err) return ServerReply (500, 'db.query failed! ' + query);
			return ServerReply(200, results);
		});
	});
}; 
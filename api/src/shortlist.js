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
	var npi1 = event.queryStringParameters.[NPI1];
	var npi2 = event.queryStringParameters.[NPI2];
	var npi3 = event.queryStringParameters.[NPI3];

 	//check params
 	if(!npi1) return ServerReply (204, 'no NPI request');
	
	//connect to the DB
	var db = mysql.createConnection({
		host:dbhost,
		user:constants.user,
		password:constants.password,
		database:constants.database
	});

	//save the selection
	var query = "INSERT INTO transactions VALUES (DEFAULT,DEFAULT,'"+ npi1 +"','"+ npi2 +"','"+npi3 +"')";
 	db.query(query, function(err,results,fields){		
		if (err) return ServerReply (500, 'db.query failed! ' + query);

		//keep the transaction number
		var transactionid= results.insertId;
			
		//return detailed data of the selected providers
		query = "SELECT NPI,Provider_Full_Name,Provider_Full_Street, Provider_Full_City, Provider_Business_Practice_Location_Address_Telephone_Number FROM npidata2 WHERE ((NPI = '"+npi1+"')";
		if(npi2) query += "OR (NPI = '"+npi2+"')";
		if(npi3) query += "OR (NPI = '"+npi3+"')";
		query += ")";

 		db.query(query, function(err,results,fields){		
			if (err) return ServerReply (500, 'db.query failed! ' + query);
			
			var info=[{Transaction: transactionid}];
			info.push(results);
			return ServerReply (200, info);
		});
	});
};
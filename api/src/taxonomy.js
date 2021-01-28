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
	var dbhost;
	try{
		dbhost = wait.for(dns.lookup,constants.host);
	} catch(err){
		return ServerReply (500, 'No DNS resolution: ' + constants.host);
	}

	var db = mysql.createConnection({
		host:dbhost,
		user:constants.user,
		password:constants.password,
		database:constants.database
	});

	var query = "SELECT * FROM taxonomy";
	db.query(query, function(err,results,fields){		
		if (err) return ServerReply (500, 'db.query failed! ' + query);
		return ServerReply (200, results);
	});
};
var constants = require("./constants.js");
var mysql=require("mysql");

function ServerReply (code, message){
	return {
		"statusCode": code,
		"headers": {
			"Access-Control-Allow-Headers": "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
			"Access-Control-Allow-Origin": "*",
			"Access-Control-Allow-Methods": "OPTIONS,GET"
		},
		"body": JSON.stringify(message)
	};
}

var db = mysql.createConnection({
	host:constants.host,
	user:constants.user,
	password:constants.password,
	database:constants.database
});

/*exports.handler = async (event) => {

	db.connect(function(err) {
		if (err) return ServerReply (500, 'mysql.connect: ' + err);
		
		var query = "SELECT * FROM taxonomy";
		db.query(query, function(err,results,fields){		
			db.end();
			if (err) return ServerReply (500, 'db.query: ' + err);
			return ServerReply (200, results);
		});

	});

	return ServerReply (500, 'never here');
};*/

exports.handler = (event, context, callback) => {

	context.callbackWaitsForEmptyEventLoop = false;

	db.connect(function(err) {
		if (err)  callback(null, ServerReply (500, 'mysql.connect: ' + err));
		
		var query = "SELECT * FROM taxonomy";
		db.query(query, function(err,results,fields){		
			db.end();
			if (err) callback(null, ServerReply (500, 'db.query: ' + err));
			callback(null, ServerReply (200, results));
		});

	});

	callback(null, ServerReply (500, 'never here'));
};
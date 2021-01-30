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

exports.handler = async (event) => {

	var db = mysql.createConnection({
		host:constants.host,
		user:constants.user,
		password:constants.password,
		database:constants.database
	});

	db.connect(function(err) {
		if (err) return ServerReply (500, 'mysql.connect: ' + err);
	});

	var query = "SELECT * FROM taxonomy";
	db.query(query, function(err,results,fields){		
		if (err) return ServerReply (500, 'db.query: ' + err);
		return ServerReply (200, [{'Classification':'Acupuncturist'},
			{'Classification':'Adult Companion'},
			{'Classification':'Advanced Practice Dental Therapist'},
			{'Classification':'Advanced Practice Midwife'},
			{'Classification':'Air Carrier'}]);
	});
			return ServerReply (500, 'never here');

};
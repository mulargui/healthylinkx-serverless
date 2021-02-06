var constants = require("./constants.js");
const mysql = require('mysql2/promise');
var http = require('http');

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

var db = mysql.createPool({
	host:constants.host,
	user:constants.user,
	password:constants.password,
	database:constants.database
});

exports.handler = async (event) => {
	if (!event.queryStringParameters)
		return ServerReply (204, {"error": 'not params!'});

	var gender = event.queryStringParameters.gender;
	var lastname1 = event.queryStringParameters.lastname1;
	var lastname2 = event.queryStringParameters.lastname2;
	var lastname3 = event.queryStringParameters.lastname3;
	var specialty = event.queryStringParameters.specialty;
	var distance = event.queryStringParameters.distance;
	var zipcode = event.queryStringParameters.zipcode;
 	
 	//check params
 	if(!zipcode && !lastname1 && !specialty)
		return ServerReply (204, {"error": 'not enought params!'});
	
 	var query = "SELECT NPI,Provider_Full_Name,Provider_Full_Street,Provider_Full_City FROM npidata2 WHERE (";
 	if(lastname1)
 		query += "((Provider_Last_Name_Legal_Name = '" + lastname1 + "')";
 	if(lastname2)
 		query += " OR (Provider_Last_Name_Legal_Name = '" + lastname2 + "')";
 	if(lastname3)
 		query += " OR (Provider_Last_Name_Legal_Name = '" + lastname3 + "')";
 	if(lastname1)
 		query += ")";
 	if(gender)
 		if(lastname1)
 			query += " AND (Provider_Gender_Code = '" + gender + "')";
 		else
 			query += "(Provider_Gender_Code = '" + gender + "')";
 	if(specialty)
 		if(lastname1 || gender)
 			query += " AND (Classification = '" + specialty + "')";
 		else
 			query += "(Classification = '" + specialty + "')";

 	//case 1: no need to calculate zip codes at a distance
 		if(zipcode)
 			if(lastname1 || gender || specialty)
 				query += " AND (Provider_Short_Postal_Code = '"+ zipcode + "')";
 			else
 				query += "(Provider_Short_Postal_Code = '" + zipcode + "')";
		query += ") limit 50";
 		
		try {
			const [rows,fields] = await db.query(query);
			return ServerReply (200, rows);
		} catch(err) {
			return ServerReply (500, {"error": query + '#' + err});
		}
}; 
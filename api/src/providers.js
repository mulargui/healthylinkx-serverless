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
	var gender = event.queryStringParameters.[gender];
	var lastname1 = event.queryStringParameters.[lastname1];
	var lastname2 = event.queryStringParameters.[lastname2];
	var lastname3 = event.queryStringParameters.[lastname3];
	var specialty = event.queryStringParameters.[specialty];
	var distance = event.queryStringParameters.[distance];
	var zipcode = event.queryStringParameters.[zipcode];
 	
 	//check params
 	if(!zipcode && !lastname1 && !specialty)
		return ServerReply (204, 'not enought params!');
	
	//connect to the DB
	var db = mysql.createConnection({
		host:dbhost,
		user:constants.user,
		password:constants.password,
		database:constants.database
	});

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
 	if (!distance || !zipcode){
 		if(zipcode)
 			if(lastname1 || gender || specialty)
 				query += " AND (Provider_Short_Postal_Code = '"+ zipcode + "')";
 			else
 				query += "(Provider_Short_Postal_Code = '" + zipcode + "')";
		query += ") limit 50";
 		
		db.query(query, function(err,results,fields){		
			if (err) return ServerReply (500, 'db.query failed! ' + query);
			return ServerReply(200, results);
		});
		return;
	}

 	//case 2:we need to find zipcodes at a distance

 	//lets get a few zipcodes
 	var queryapi = "/rest/GFfN8AXLrdjnQN08Q073p9RK9BSBGcmnRBaZb8KCl40cR1kI1rMrBEbKg4mWgJk7/radius.json/" + zipcode + "/" + distance + "/mile";
	var responsestring="";

	var options = {
  		host: "zipcodedistanceapi.redline13.com",
  		path: queryapi
 	};

	var req = require("http").request(options, function(res) {
		res.setEncoding('utf8');
		res.on('data', function (chunk) {
			responsestring += chunk;
		});

		res.on('error', function(e) {
			return ServerReply (500, 'error getting zipcodes!' + e);
		});	

		res.on('end', function() {

			//no data
  			if (!responsestring) return ServerReply (204, 'no zipcodes!');

		 	//translate json from string to array
			var responsejson = JSON.parse(responsestring);
			var length=responsejson.zip_codes.length;

			//complete the query
 			if(lastname1 || gender || specialty)
 				query += " AND ((Provider_Short_Postal_Code = '"+responsejson.zip_codes[0].zip_code+"')";
 			else
 				query += "((Provider_Short_Postal_Code = '"+responsejson.zip_codes[0].zip_code+"')";
			for (var i=1; i<length;i++){
 				query += " OR (Provider_Short_Postal_Code = '"+ responsejson.zip_codes[i].zip_code +"')";
			}
  			query += ")) limit 50";

			db.query(query, function(err,results,fields){		
				if (err) return ServerReply (500, 'db.query failed! ' + query);
				return ServerReply(200, results);
			});
		});
	}).end();		
}; 
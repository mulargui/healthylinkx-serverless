exports.handler = async (event) => {
	
    const response = {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Headers": "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "OPTIONS,GET"
        },
        "body": JSON.stringify([{'Classification':'Acupuncturist'},
			{'Classification':'Adult Companion'},
			{'Classification':'Advanced Practice Dental Therapist'},
			{'Classification':'Advanced Practice Midwife'},
			{'Classification':'Air Carrier'}])
    };
    return response;
};
exports.handler = async (event) => {
	
    const response = {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Headers": "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "OPTIONS,GET"
        },
        "body": JSON.stringify(['Acupuncturist','Adult Companion','Advanced Practice Dental Therapist','Advanced Practice Midwife','Air Carrier'])
    };
    return response;
};
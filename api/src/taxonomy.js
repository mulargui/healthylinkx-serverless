exports.handler = async (event) => {

    const response = {
        "statusCode": 200,
        "body": JSON.stringify(['Acupuncturist','Adult Companion','Advanced Practice Dental Therapist','Advanced Practice Midwife','Air Carrier'])
    };
    return response;
};
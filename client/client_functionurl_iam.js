const https = require('https');
const aws4 = require('aws4');

//  TODO: Get fromIni to work
const { fromIni } = require("@aws-sdk/credential-providers"); // ES6 import

const credentials = {}
const lambda = {}
const args = process.argv.splice(2)
args.forEach((val) => {
    const key = val.split("=")[0]
    console.log()
    switch (key) {
        case 'ACCESS_KEY_ID':
            credentials['accessKeyId'] = val.split("=")[1];
            break
        case 'SECRET_ACCESS_KEY':
            credentials['secretAccessKey'] = val.split("=")[1];
            break
        case 'REGION':
            credentials['region'] = val.split("=")[1];
            break
        case 'HOST':
            lambda['host'] = val.split("=")[1];
            break
        case 'ENDPOINT':
            lambda['endpoint'] = val.split("=")[1];
            break
    }
})

// console.log('CREDENTIALS: ' + JSON.stringify(credentials))
if (!credentials['accessKeyId'] || !credentials['secretAccessKey'] || !credentials['region']) {
    console.log('credentials not set: ACCESS_KEY_ID, SECRET_ACCESS_KEY, REGION');
    console.log('Usage:\nnode client_functionurl_iam.js\nACCESS_KEY_ID="ABC123"\nSECRET_ACCESS_KEY="XYZ098"\nREGION="us-west-1"\nHOST="hxhkzm5bru3dwjxgx5k33n4f2y0yqlzr.lambda-url.us-west-1.on.aws"\nENDPOINT="/hello"');
    throw new Error('credentials not set')
}

if (!lambda['host'] || !lambda['endpoint']) {
    console.log('host values not set: HOST, ENDPOINT');
    console.log('Usage:\nnode client_functionurl_iam.js\nACCESS_KEY_ID="ABC123"\nSECRET_ACCESS_KEY="XYZ098"\nREGION="us-west-1"\nHOST="hxhkzm5bru3dwjxgx5k33n4f2y0yqlzr.lambda-url.us-west-1.on.aws"\nENDPOINT="/hello"');
    throw new Error('lambda values not set')
}

const options = {
    hostname: lambda.host,
    port: 443,
    path: lambda.endpoint,
    headers: {
        'Host': lambda.host,
    },
}

const signer = aws4.sign({
        service: 'lambda',
        region: 'us-west-1',
        path: lambda.endpoint,
        headers: options.headers,
        method: options.method,
        body: '',
    },
    // TODO: I can't get this to work :(
    // fromIni({
    //     profile: 'default'
    // })
    /*{
        // THIS WORKS
        accessKeyId: process.env.ACCESS_KEY_ID,
        secretAccessKey: process.env.SECRET_ACCESS_KEY,
        region: process.env.REGION
    }*/
    credentials
);

Object.assign(options.headers, signer.headers);

https.get(options, (res) => {
    let rawData = "";
    res.on("data", (chunk) => {
        rawData += chunk;
    });
    res.on("end", () => {
        const parsedData = JSON.parse(rawData);
        console.log(parsedData);
    });
});

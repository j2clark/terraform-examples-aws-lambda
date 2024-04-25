const https = require('https');

const lambda = {}
const args = process.argv.splice(2)
args.forEach((val) => {
    const key = val.split("=")[0]
    console.log()
    switch (key) {
        case 'HOST':
            lambda['host'] = val.split("=")[1];
            break
        case 'ENDPOINT':
            lambda['endpoint'] = val.split("=")[1];
            break
    }
})

if (!lambda['host'] || !lambda['endpoint']) {
    console.log('host values not set: HOST, ENDPOINT');
    console.log('Usage:\nnode client_functionurl_iam.js\nACCESS_KEY_ID="ABC123"\nSECRET_ACCESS_KEY="XYZ098"\nREGION="us-west-1"\nHOST="hxhkzm5bru3dwjxgx5k33n4f2y0yqlzr.lambda-url.us-west-1.on.aws"\nENDPOINT="/hello"');
    throw new Error('lambda values not set')
}


// const host = 'cmplw6o4ucwgwigyflofibe6em0fowbv.lambda-url.us-west-1.on.aws'
// const canonicalURI = '/hello';
const options = {
    hostname: lambda.host,
    port: 443,
    path: lambda.endpoint,
    headers: {
        'Host': lambda.host,
    },
}
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

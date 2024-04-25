
## Client Setup

install node dependencies
```shell
cd client
nom install
```

## Run Clients

### Public Lambda Endpoint
```shell
node client_functionurl.js HOST="hxhkzm5bru3dwjxgx5k33n4f2y0yqlzr.lambda-url.us-west-1.on.aws" ENDPOINT="/hello"
```


### IAM Lambda Endpoint
```shell
node client_functionurl_iam.js HOST="cmplw6o4ucwgwigyflofibe6em0fowbv.lambda-url.us-west-1.on.aws" ENDPOINT="/hello" ACCESS_KEY_ID=$AWS_ACCESS_KEY SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY REGION=AWS_REGION
```

#### Signing IAM Lambda FunctionURL

I have not been able to get the logic to load credentials from my local ~/.aws/credentials to work

I am manually creating a credentials struct, which works
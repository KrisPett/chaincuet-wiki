
### Setup Lambda

```
Create Lambda function
Default will put logs in cloudwatch (cost money for logs storage)
Create iam policy
Create user and attach policy
Create credentials and use in node app
```

#### Policy example

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowInvoke",
            "Effect": "Allow",
            "Action": "lambda:InvokeFunction",
            "Resource": "arn:aws:lambda:us-east-1:<>:function:<>"
        }
    ]
}
```

#### Example node

```jsx
const lambda = new Lambda({
  region: 'us-east-1',
  credentials: new Credentials({
    accessKeyId: process.env.NEXT_PUBLIC_AWS_ACCESS_KEY_ID || "",
    secretAccessKey: process.env.NEXT_PUBLIC_AWS_SECRET_ACCESS_KEY || ""
  })
});

const params: InvocationRequest = {
    FunctionName: 'test',
    Payload: JSON.stringify({
    "key1": "value1",
    "key2": "value2",
    "key3": "value3"
    }),
};

lambda.invoke(params).promise().then(res => {
    res.Payload && console.log(JSON.parse(res.Payload.toString()))
});
```

#### Exmaple how to use npm libraries in Lambda
```
npm init -y
npm install @sendgrid/mail
zip the new folder and import in aws lambda
```

#### Timeout

```
Set timeout to 30 seconds or Internal server error will be thrown
```

#### Allow lambda to put object in s3

```
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::s3_bucket/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::cloudfront_distribution_id"
                }
            }
        },
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::<role_that_has_s3_put_permissions>"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::s3_bucket/*"
        }
    ]
}
```

### Api-Gateway

#### Using Api-Gateway to trigger lambda functions 

```jsx
fetch("https://vd56h5ip1a.execute-api.us-east-1.amazonaws.com/sendgrip-stage/send-email", {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({
        name: form.name,
        email: form.email,
        message: form.message
        })
    }).then(r => console.log(r))
    .catch(e => console.log(e))
}
```
#### Rest Api

```
Does not support JWT
```

#### HTTP Api

```
Can be used with JWT (keycloak)
Configure CORS in api-gateway
Access-Control-Allow-Origin = *
Access-Control-Allow-Headers = authorization content-type
Access-Control-Allow-Methods = GET,POST,OPTIONS

Authorization
Issuer = https://keycloak.example.com/auth/realms/<realm>
Audience = <client-id> or account
Identity source = $request.header.Authorization
```

#### Using Api-Gateway to trigger lambda functions

```jsx
import { Configuration, OpenAIApi } from "openai";

const configuration = new Configuration({
  apiKey: process.env.NEXT_PUBLIC_OPEN_AI
});

const openai = new OpenAIApi(configuration);

export const handler = async (event, context, callback) => {
  if (!configuration.apiKey) {
    return callback(new Error("No API key found"));
  }
  const requestBody = JSON.parse(event.body);
  const {text, model} = requestBody;

  try {
    const response = await openai.createCompletion({
      model: model,
      prompt: text,
      temperature: 0,
      max_tokens: 100
    });
    const responseData = response.data;

    return callback(null, {
      statusCode: 200,
      body: JSON.stringify(responseData)
    });
  }
  catch (err) {
    return callback(err);
  }

};
```

#### Test Lambda Example

```
{
  "body": "{\"text\":\"A cat \"}"
}
```

#### Using Authorization header

```
Authorization might be lower case authorization when using HTTP and not REST
const access_token = event.headers.authorization;
```
{
  "body": "{\"text\":\"A cat \"}"
}
```

### CloudWatch

``` 
Edit retention to expire logs after 1 day
```
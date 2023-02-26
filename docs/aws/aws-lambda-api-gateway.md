
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

### Api-Gateway

#### Using Api-Gateway to trigger lambda

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

### CloudWatch

``` 
Edit retention to expire logs after 1 day
```
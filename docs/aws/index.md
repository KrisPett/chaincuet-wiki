#### AWS Setup Credentials

#### 
```
aws configure

export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id) && \
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
```

#### Static websites

```
s3 -> cloudfront -> route53 - cert
```



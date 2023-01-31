#### Policies
```
# Allow Cloudfront using s3 block public access
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
                "Resource": "arn:aws:s3:::<>.com/*",
                "Condition": {
                    "StringEquals": {
                      "AWS:SourceArn": "arn:aws:cloudfront::<>:distribution/<>"
                    }
                }
            }
        ]
      }

# Use to access with block public access turned iff
      {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowS3SyncCommand",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject",
                "s3:Listbucket",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::<>.com",
                "arn:aws:s3:::<>.com/*"
            ]
        }
    ]
}
```

#### Cloudfront setup
```
Need Alternative domains because of route53
Set Default Root object
Use Origin access control settings (recommended)
Update policy in s3
```

#### Create iam role for s3 bucket for pipeline
```
s3-bucket-cloudfront user
Permissions:
allow-invalidation - so clodufront can refresh
Cloudfront refresh cache every 24 hours
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "cloudfront:CreateInvalidation",
            "Resource": "*"
        }
    ]
}
AmazonS3FullAccess 
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
    ]
}
```

#### Using cloudfront with s3 website endpoint instead requires special policy

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadAccess",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::<>.com/*",
            "Condition": {
                "StringEquals": {
                    "aws:UserAgent": "Amazon CloudFront"
                }
            }
        }
    ]
}
```

#### Change CORS policy for s3
```
[
    {
        "AllowedHeaders": [
            "*"
        ],
        "AllowedMethods": [
            "GET"
        ],
        "AllowedOrigins": [
            "http://localhost:3000"
        ],
        "ExposeHeaders": [],
        "MaxAgeSeconds": 3000
    }
]
```

#### Download S3 file using Javascript fetch

```jsx
const fetchDownloadMaterial = (filename: string) => {
  const extractFilename = filename.split('/').pop();
  if (!extractFilename) throw new Error("Filename is undefined");
  return fetch(`${filename}`, {method: "GET"})
    .then(res => res.blob())
    .then(blob => {
      const url = window.URL.createObjectURL(blob)
      const a = document.createElement("a")
      a.href = url
      a.download = extractFilename
      document.body.appendChild(a)
      a.click()
      a.remove()
    })
    .catch(err => {
      console.error("err: ", err);
    })
};
```

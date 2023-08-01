### IAM Policies
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

**Create iam role for s3 bucket for pipeline**
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

**Using cloudfront with s3 website endpoint instead requires special policy**

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

#### CORS policy for s3

```
[
    {
        "AllowedHeaders": [
            "*"
        ],
        "AllowedMethods": [
            "GET",
            "PUT"
        ],
        "AllowedOrigins": [
            "http://localhost:3000"
        ],
        "ExposeHeaders": [],
        "MaxAgeSeconds": 3000
    }
]
```

#### CORS policy for cloudfront

**To fetch and download from s3**

```
Response headers policy - optional
Make a custom policy that allows all origins
```

### AWS SDK

#### Setup s3

```jsx
import AWS from "aws-sdk";
yarn add aws-sdk
npm i aws-sdk

const s3 = new AWS.S3({
  credentials: {
    accessKeyId: process.env.NEXT_PUBLIC_REACT_APP_AWS_ACCESS_KEY_ID || "",
    secretAccessKey: process.env.NEXT_PUBLIC_REACT_APP_AWS_SECRET_ACCESS_KEY || ""
  },
  region: process.env.NEXT_PUBLIC_REACT_APP_AWS_REGION || ""
});
```

#### Upload file to s3
```jsx
  const sourceUrl = 'https://images.unsplash.com/...';
  
  fetch(sourceUrl)
    .then(response => response.blob())
    .then(blob => {
      const splitUrl = sourceUrl.split('/').pop();
      if (!splitUrl) throw new Error("Filename is undefined");
      const s3Params = {
        Bucket: <bucket_name>,
        Key: 'images/' + splitUrl,
        Body: blob,
        ContentType: blob.type
      };

      s3.upload(s3Params, (err: any, data: { Location: any; }) => {
        if (err) {
          console.log('Error uploading file: ', err);
        } else {
          console.log('File uploaded successfully. Location:', data.Location);
        }
      });
    })

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

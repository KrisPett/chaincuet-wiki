### DynamoDB Setup

#### Cost

```
On demand pricing
Cost for one table:
Total read capacity units = 5
Total write capacity units = 5
Estimated monthly cost = $2.91 / month | 29,10 SEK / month
```

#### Setup

```
Create table with primary key = id
Create item
```

#### Example table

**Setup**
- Table name = user_images
- Partition Key: userId (String) value = qsqsqsq-sqsqsq-qsqsqs-qsqsq
- Sort Key: imagesCollectionId (String)

**Attributes**
- imagesId (String)
- url (String)
- timestamp: (String)

***Item for each user***

```jsx
{
 "userId": "awdawdawd-awdawdawd-awdawd-awdawdawd-awdawdawd",
 "imagesCollection": [
  {
   "images": [
    {
     "imageId": "awdawdawd-awdawdawd-awdawd-awdawdawd-awdawdawd",
     "url": "https://s3.amazonaws.com/awdawdawd-awdawdawd-awdawd-awdawdawd-awdawdawd"
    },
    {
     "imageId": "09ed4bf2-e43c-4a25-804b-5f55bc94090d",
     "url": "https://s3.amazonaws.com/awdawdawd-awdawdawd-awdawd-awdawdawd-awdawdawd"
    },
    {
     "imageId": "a49da393-db67-4886-951c-a9a63b66348b",
     "url": "https://s3.amazonaws.com/awdawdawd-awdawdawd-awdawd-awdawdawd-awdawdawd"
    },
    {
     "imageId": "f0116257-4c8d-4edb-b48e-cbe500a67d6a",
     "url": "https://s3.amazonaws.com/awdawdawd-awdawdawd-awdawd-awdawdawd-awdawdawd"
    }
   ],
   "imagesCollectionId": "awdawdawd-awdawdawd-awdawd-awdawdawd-awdawdawd",
   "timestamp": "2022-03-21T10:30:00Z"
  }
 ]
}
```

### AWS-cli

#### Create Table

```jsx
import {CreateTableInput} from "aws-sdk/clients/dynamodb";
const handler = async (req: NextApiRequest, res: NextApiResponse) => {
  if(token){
    const params: CreateTableInput = {
      TableName: 'user-images-test',
      KeySchema: [
        { AttributeName: 'userId', KeyType: 'HASH' },
      ],
      AttributeDefinitions: [
        { AttributeName: 'userId', AttributeType: 'S', },
      ],
      ProvisionedThroughput: {
        ReadCapacityUnits: 1,
        WriteCapacityUnits: 1,
      },
    };

    try {
      const data = await dynamodb.createTable(params).promise();
      console.log(data);
      res.status(200).json({ message: 'Table created successfully' });
    } catch (err) {
      console.log(err);
      res.status(500).json({ message: 'Failed to create table' });
    }
  }

}
export default handler;
```

#### Put Item

```jsx
import {PutItemInput} from "aws-sdk/clients/dynamodb";
import {decode} from "jsonwebtoken";

const handler = async (req: NextApiRequest, res: NextApiResponse) => {
  const access_token = req.headers.authorization
  const token = access_token?.replace('Bearer ', '')
  if (token) {
    const subId = decode(token)?.sub as string
    const params: PutItemInput = {
      TableName: "user-images-test",
      Item:
        {
          "userId": {
            "S": subId
          },
          "imagesCollection": {
            "L": [
              {
                "M": {
                  "images": {
                    "L": [
                      {
                        "M": {
                          "imageId": {
                            "S": "cb9a75a2-2553-4c9f-ab0a-1388c54d6621"
                          },
                          "url": {
                            "S": "https://s3.amazonaws.com/"
                          }
                        }
                      },
                      {
                        "M": {
                          "imageId": {
                            "S": "09ed4bf2-e43c-4a25-804b-5f55bc94090d"
                          },
                          "url": {
                            "S": "https://s3.amazonaws.com/"
                          }
                        }
                      },
                      {
                        "M": {
                          "imageId": {
                            "S": "a49da393-db67-4886-951c-a9a63b66348b"
                          },
                          "url": {
                            "S": "https://s3.amazonaws.com/"
                          }
                        }
                      },
                      {
                        "M": {
                          "imageId": {
                            "S": "f0116257-4c8d-4edb-b48e-cbe500a67d6a"
                          },
                          "url": {
                            "S": "https://s3.amazonaws.com/"
                          }
                        }
                      }
                    ]
                  },
                  "imagesCollectionId": {
                    "S": "5ec5d9a2-3104-4472-89ad-fc45bf4ade51"
                  },
                  "timestamp": {
                    "S": "2022-03-21T10:30:00Z"
                  }
                }
              }
            ]
          }
        }
    }
    try {
      const data = await dynamodb.putItem(params).promise();
      console.log(data);
      res.status(200).json({message: 'Put item created successfully'});
    } catch (err) {
      console.log(err);
      res.status(500).json({message: 'Failed to create item'});
    }
  }

}
export default handler;
```


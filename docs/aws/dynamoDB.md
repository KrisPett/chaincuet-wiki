#### DynamoDB Setup


```

```

#### Cost

```
On demand pricing
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



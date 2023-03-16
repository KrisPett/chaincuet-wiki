
# DALL·E

Download image causing CORS block, must use nextjs backend to download image and upload to s3

#### Nextjs backend

```jsx
import {NextApiRequest, NextApiResponse} from "next";
import AWS from "aws-sdk";
import process from "process";
import axios from "axios";

const s3 = new AWS.S3({
  credentials: {
    accessKeyId: process.env.NEXT_PUBLIC_REACT_APP_AWS_ACCESS_KEY_ID || "",
    secretAccessKey: process.env.NEXT_PUBLIC_REACT_APP_AWS_SECRET_ACCESS_KEY || ""
  },
  region: process.env.NEXT_PUBLIC_REACT_APP_AWS_REGION || ""
});

const handler = async (req: NextApiRequest, res: NextApiResponse) => {
  const sourceUrl = 'https://oaidalleapiprodscus....';
  try {
    const response = await axios.get(sourceUrl, {responseType: 'arraybuffer'});
    const splitUrl = sourceUrl.split('/').pop();
    const s3Params = {
      Bucket: <bucker_name>,
      Key: 'images/' + splitUrl,
      Body: response.data,
      ContentType: response.headers['content-type'],
    };
    const result = await s3.upload(s3Params).promise();
    console.log('File uploaded successfully. Location:', result.Location);
    res.status(200).json({message: 'Success'});
  } catch (error) {
    console.error('Error uploading file:', error);
    res.status(500).json({message: 'Error uploading file'});
  }
};

export default handler;

```
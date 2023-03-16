
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
  const {text} = req.body;

  openai.createImage({prompt: text, n: 4, size: "256x256"})
    .then(async (data) => {
      const responseImages = [];
      if (data.data.data) {
        const urls = data.data.data
        for (const url of urls) {
          if (url.url) {
            const response = await axios.get(url.url, {responseType: 'arraybuffer'});
            const uuid = uuidv4();
            const s3Params = {
              Bucket: <bucket_name>,
              Key: 'images/' + uuid,
              Body: response.data,
              ContentType: response.headers['content-type'],
            };
            const result = await s3.upload(s3Params).promise();
            console.log(`File uploaded successfully. Location:`, result.Location);
            responseImages.push(result.Location);
          }
        }
      }
      res.status(200).json(responseImages);
    })
    .catch((error) => {
      console.error('Error creating images:', error);
      res.status(500).json({message: 'Error creating images'});
    });
};

```
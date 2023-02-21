#### Host a Node sever using Elastic Container Service
https://github.com/aws-actions/amazon-ecr-login

1. Create Elastic Container Registry to store docker image (private repo)
2. Create ECS Cluster using AWS Fargate (serverless) 
- On Create ECS it creates IAM role AmazonECSServiceRolePolicy

3.  Create Task Definition
4.  Create Github Workflow - build image - push image to ECR
- Alternatively use AWS CodePipeline and AWS CodeBuild (cost extra)

##### IAM Roles needed for Github Workflow

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ECRAccess",
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:PutImage"
            ],
            "Resource": "arn:aws:ecr:us-east-1:123456789012:repository/my-ecr-repo"
        }
    ]
}

```

5.  Trigger the Task Definition and refresh the ECS to new build
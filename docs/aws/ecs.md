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
# https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
# Configure provider on aws using Github OIDC to link the role to the workflow
# URL: https://token.actions.githubusercontent.com, Audience: sts.amazonaws.com

# Create Role (Web identity) and attach the policy
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam:::oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:acccountName/repoName:*"
                }
            }
        }
    ]
}

# Policy for identity provider
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:BatchDeleteImage",
                "ecr:ListImages",
                "ecr:DescribeImages"
            ],
            "Resource": "arn..."
        },
        {
            "Sid": "AllowDescribeRepoImage",
            "Effect": "Allow",
            "Action": "ecr:DescribeRepositories",
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "ecr:GetAuthorizationToken",
            "Resource": "*"
        }
    ]
}

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "RegisterTaskDefinition",
            "Effect": "Allow",
            "Action": [
                "ecs:RegisterTaskDefinition",
                "ecs:DescribeTaskDefinition"
            ],
            "Resource": "*"
        },
        {
            "Sid": "PassRolesInTaskDefinition",
            "Effect": "Allow",
            "Action": [
                "iam:PassRole"
            ],
            "Resource": [
                "arn:aws:iam::accountId:role/ecsTaskExecutionRole"
            ]
        },
        {
            "Sid": "DeployService",
            "Effect": "Allow",
            "Action": [
                "ecs:UpdateService",
                "ecs:DescribeServices"
            ],
            "Resource": [
                "arn for service"
            ]
        }
    ]
}
```

5.  Trigger the Task Definition and refresh the ECS to new build
6.  Task Definition is a template for the container to run on ECS (similar to docker-compose)
7. Create a Service and specify security group
#### ECS

##### Host a Node sever using Elastic Container Service

1. Create Elastic Container Registry to store docker image (private repo)
2. Create ECS Cluster using AWS Fargate (serverless) 
- On Create ECS it creates IAM role AmazonECSServiceRolePolicy

3.  Create Task Definition
4.  Create Github Workflow - build image - push image to ECR
- Alternatively use AWS CodePipeline and AWS CodeBuild (cost extra)

5.  Trigger the Task Definition and refresh the ECS to new build
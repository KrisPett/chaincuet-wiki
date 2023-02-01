### Collection of Terraforms

#### Setup
```
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id) && \
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
```

#### Initialized
```
terraform init
```

#### Format .tf File
```
terraform fmt
```

#### Validate
```
terraform validate
```

#### Create Resources
```
terraform apply
```

#### Remove Resources
```
terraform destroy
```

#### Import from AWS
```
terraform import aws_s3_bucket.example <bucket_name>
aws_s3_bucket=the resource type
.example=name from the .tf file

```

#### Note

<p>
The Terraform state file (terraform.tfstate) contains information about the infrastructure managed by Terraform, including the resources it created, their current state, and metadata. This information is sensitive because it can be used to access and manipulate the underlying infrastructure, which may contain sensitive data or control critical systems. As such, it is important to secure the Terraform state file by keeping it confidential and protecting it from unauthorized access or modification. This can be achieved by using version control systems, backing up the state file, and using Terraform's remote state functionality to store it securely in a centralized location.
</p>
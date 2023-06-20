![springcloud](https://images.chaincuet.com/wiki/aws-arch.gif)
#### AWS Setup Credentials

#### 
```
aws configure

export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id) && \
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
```

#### Static websites

```
s3 -> cloudfront -> route53 - cert
```

#### EC2

```
Price: $0.023 per On Demand Linux t2.small Instance Hour
$0.023 x 24 hours/day x 30 days/month = $16.56 per month

EBS (Elastic Block Store) Price: $0.10 per GB-month of General Purpose SSD
```

#### ECS Architecture

```
ECS -> ECR -> ALB -> Route53

ALB Price $0.0225 per Application Load Balancer-hour (or partial hour)
-> 24 hours/day * 30 days/month = 720 hours/month = $16.20/month
Minimun resouces in task-definition .5gGB RAM | 0.25 vCPU
```

#### Prod Architecture VPC jump-server
Elastic IPs

- jump-server -> ssh
- ssh1 -> frontends -> subnet public (igw)
- ssh2 -> backends -> subnet public (igw)
- ssh3 -> keycloak auth server -> subnet public (igw)
- ssh4 -> database -> subnet private (nat)

Setup VPC

- Create VPC (CIDR block)
- Create Subnets (two public and one private)
- Create an Internet Gateway (IGW)
- Create Elastic IPs:
- Create a NAT Gateway:
  Select the public subnet for the NAT gateway.
  Create a route table for the private subnet. Add a route to the NAT gateway. Associate the route table with the private subnet. 
- Launch Jump Server Instance (nano) in one public subnet
- Launch frontend-server in another public subnet
- Launch backend-server in another public subnet or private subnets
- Launch Keycloak Auth Server Instance in another public subnet
- Launch database server Instance in private subnet (NAT), keycloak auth server can access it

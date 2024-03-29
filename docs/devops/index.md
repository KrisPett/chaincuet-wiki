#### Processor Architecture

```uname -m```

**x64-based virtual machines**
x64-based virtual machines use the 64-bit x86 instruction set architecture, widely used in desktop and server
environments. They offer compatibility with various operating systems and software. x64 processors are known for their
strong performance in complex calculations and multi-threading. Commonly used for general-purpose computing, web
hosting, database management, and enterprise workloads. Suitable when software compatibility and high-performance
computing are essential.

**Arm64-based virtual machines**
Arm64-based virtual machines use the 64-bit ARM architecture, commonly found in mobile devices and low-power systems.
They offer good performance per watt and excel in parallel processing. Arm64 VMs are suitable for IoT, edge computing,
and containerized workloads. Software compatibility may be limited compared to x64. Ideal for scenarios prioritizing
energy efficiency and ARM-specific optimizations.
Amazon Web Services (AWS)

**Choose x64-based virtual machines when:**

- Compatibility: You need broad OS and software support with traditional x86-64 applications.
- High Performance: For complex calculations and memory-intensive workloads.
- General-purpose Computing: Web hosting, databases, and various enterprise applications.
- Established Ecosystem: Well-established with extensive software and tooling options.
- No Energy Constraints: Energy efficiency is less critical compared to performance.

**Choose Arm64-based virtual machines when:**

- Energy Efficiency: You prioritize power efficiency and performance per watt.
- IoT and Edge: For IoT devices, edge computing, and low-power applications.
- Containerized Workloads: Taking advantage of ARM-specific container optimizations.
- Specific ARM Software: When applications are compiled and optimized for ARM architecture.
- Future Growth: As the ARM ecosystem expands, more software support will become available.

### Amazon Web Services

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
t2.small
Price: $0.023 per On Demand Linux t2.small Instance Hour
$0.023 x 24 hours/day x 30 days/month = $16.56 per month (180.22 SEK)

t2.medium
Price: $0.0464 per On Demand Linux t2.medium Instance Hour
$0.0464 x 24 hours/day x 30 days/month = $33.408 per month (363.57 SEK)

t2.large
Price: $0.0928 per On Demand Linux t2.large Instance Hour
$0.0928 x 24 hours/day x 30 days/month = $67.1232 per month (730.48 SEK)

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

### Chaincue resources

| Database Name                       | Size   |
|-------------------------------------|--------|
| postgres                            | 46 MB  |
| chainue_real_estate                 | 60 MB  |
| chaincue-real-estate-go-prod        | 14 MB  |
| chaincue-real-estate-redis          | 6 MB   |
| kc                                  | 576 MB |
| vault                               | 248 MB |
| consul                              | 34 MB  |
| chainbot                            | 55 MB  |
| pgadmin_03_25_23                    | 140 MB |

**sum:** 46 MB + 60 MB + 14 MB + 6 MB + 576 MB + 248 MB + 34 MB + 55 MB + 140 MB = 1189 MB
**server:** = 1338 MB - 1189 MB = **149 MB is used for Linux OS**



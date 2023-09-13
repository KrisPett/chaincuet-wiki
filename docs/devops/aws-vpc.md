#### Setup VPC

- Create VPC (CIDR block)
- Create Subnets (two public and one private)
- Create an Internet Gateway (IGW)
- Create Elastic IPs:
- Create a NAT Gateway:
  Select the public subnet for the NAT gateway.
  Select Elastic IP (max 5 per account)
  Update route table with the nat (Edit routes) 0.0.0.0/0 -> nat

- Launch Jump Server Instance (nano) in one public subnet
- Launch frontend-server in another public subnet
- Launch backend-server in another public subnet or private subnets
- Launch Keycloak Auth Server Instance in another public subnet
- Launch database server Instance in private subnet (NAT), keycloak auth server can access it

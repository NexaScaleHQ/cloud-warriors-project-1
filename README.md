# nginx web-server on aws with terraform

## Setup VPC and networking topology.
- Create VPC
- Create Internet gateway
- Create custom route table
- Create a subnet
- Associate subnet with route table
- Create Security Group to allow port 22, 80, 443

## Provision Compute Service

- Create Key-pair
- Create Compute instance (ec2)
- Launch ngnix-server script on instance

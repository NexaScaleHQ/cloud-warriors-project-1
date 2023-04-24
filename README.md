# nginx web-server on aws with terraform

# Introduction

This is a simple example of how to create a web-server on aws using terraform. The web-server will be created in a VPC with a public and private subnet. The web-server will be exposed to the public internet via an internet gateway. The web-server will be able to access the internet via a NAT gateway.

# Prerequisites

* An AWS account.
# Setup
## Backend State Configuration
```hashicorp
terraform {
  backend "s3" {
    bucket  = "team-warriors-web-server-backend-state"
    key     = "team-warriors-web-server/development/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
```

# Setup VPC and Networking topology.
## Create VPC
```hashicorp
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.env_prefix}-main_vpc"
  }
}

```
  * A **VPC** is a virtual private cloud. It is a virtual network dedicated to your AWS account. It is logically isolated from other virtual networks in the AWS Cloud. You can launch your AWS resources, such as Amazon EC2 instances, into your VPC. You can specify an IP address range for the VPC, add subnets, associate security groups, and configure route tables.
  * The **cidr_block** specifies the range of ip addresses that will be used by the VPC.
  * The **enable_dns_support** specifies that the VPC will be assigned a DNS hostname.
  * The **enable_dns_hostnames** specifies that the VPC will be assigned a DNS hostname.

![vpc](/assests/vpc.png)

## Create Internet gateway

```hashicorp

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env_prefix}-web-server-igw"
  }
}
```
  * An **internet gateway** is a horizontally scaled, redundant, and highly available VPC component that allows communication between instances in your VPC and the internet. It therefore imposes no availability risks or bandwidth constraints on your network traffic.
  * The **vpc_id** specifies the VPC that the internet gateway will be created in.

![igw](/assests/igw.png)

## Create a public subnet (2)
```hashicorp
resource "aws_subnet" "public_subnets" {
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, 2 + count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = "true"
  count                   = var.public_subnets_count

  tags = {
    Name = "${var.env_prefix}-web-server-public-subnet"
  }

}
```
  * A **public subnet** with in our VPC that we can launch resources into that we want to be auto-assigned a public ip addresses.  These resources will be exposed to the public internet, with public IPs, by default. They don't need to go through, and aren't shielded by NAT Gateway.
  * The **cidr_block** specifies the range of ip addresses that will be used by the subnet.
  * The **availability_zone** specifies the availability zone that the subnet will be created in.
  * The **map_public_ip_on_launch** specifies that the subnet will be assigned a public ip address.
  * The **count** specifies the number of public subnets that will be created.

## Create a private subnet (2)

```hashicorp
resource "aws_subnet" "private_subnets" {
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false
  count                   = var.private_subnets_count

  tags = {
    Name = "${var.env_prefix}-web-server-private-subnet"
  }
}

```

  * A **private subnet** with in our VPC that we can launch resources into that we don't want to be auto-assigned a public ip addresses.  These resources will not be exposed to the public internet, by default. They will need to go through, and will be shielded by NAT Gateway.
  * The **cidr_block** specifies the range of ip addresses that will be used by the subnet.
  * The **availability_zone** specifies the availability zone that the subnet will be created in.
  * The **map_public_ip_on_launch** specifies that the subnet will not be assigned a public ip address.
  * The **count** specifies the number of private subnets that will be created.

![subnets](/assests/subnets.png)

## Create route table and Associate subnet with route table

```hashicorp
resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = {
    Name = "${var.env_prefix}-web-server-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = var.public_subnets_count
  subnet_id      = element(var.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}
```
  * A route_table will be created for the public subnets. This will allow the public subnets to access the internet. 
  * The route_table_association will associate the route_table with the public subnets.
  * Similarly for the private subnets.

![rt](/assests/rt.png)

## Create NAT Gateway
  
```hashicorp
  resource "aws_eip" "eip_for_the_nat_gateway" {
  vpc = true

  tags = {
    Name = "${var.env_prefix}-web-server-eip-for-the-nat-gateway"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip_for_the_nat_gateway.id
  subnet_id     = element(var.public_subnets.*.id, 0)

  tags = {
    Name = "${var.env_prefix}-web-server-nat-gateway"
  }
}
```
  * A **NAT Gateway** is a highly available AWS managed service that makes it easy to connect to the Internet from instances within a private subnet in an Amazon Virtual Private Cloud (Amazon VPC). Previously, you needed to launch a NAT instance to enable NAT for instances in a private subnet. NAT Gateway provides better availability, higher bandwidth, and requires less administrative effort.
  * The **allocation_id** specifies the allocation id of the elastic ip address that will be used by the NAT Gateway.
  * The **subnet_id** specifies the subnet that the NAT Gateway will be created in.

![nat](/assests/nat.png)
# Provision Compute Service

## Create Security Group to allow port 22, 80, 443

```hashicorp
resource "aws_security_group" "allow-web-security-group" {
  vpc_id      = var.vpc_id
  description = "Allow web inbound traffic"
  name        = "allows_web_traffic"

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    description = "HTTPS in public subnet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS in public subnet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-web"
  }
}

```
  This security group will be used to allow traffic to the web-server. Where the bastion instance will be used to connect to the private instance through ssh.
  * The **ingress** specifies the ports that will be allowed to the web-server. Here we specify the port (22) that will be allowed to the
  web-server from the bastion instance, and the ports (80, 443) that will be allowed to the web-server from the public instance.

  * The **egress** specifies the ports that will be allowed from the web-server. Here we specify all ports that will be allowed from the web-server to the public instance.

![sg](/assests/sg.png)

## Create Key-pair

```hashicorp
  resource "aws_key_pair" "bastion" {
    key_name   = "bastion-key"
    public_key = file(var.public_key_path)
  }
```
  * public_key_path: This is the path to the public key on your local machine. It can be generated using the `ssh-keygen` command.
  * key_name: This is the name of the key-pair that will be created on aws.
  **The above example is for the bastion instance. The same applies to the public instance.**

![key-pair](/assests/key-pairs.png)

## Create Compute instances (ec2)
  
```hashicorp

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "nginx-instance" {
  ami                    = data.aws_ami.latest-amazon-linux-image.value
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ngnix-server-key-pair.key_name
  vpc_security_group_ids = [var.security_group_allow_web]
  subnet_id              = element(var.public_subnets, 0).id

  user_data = file("./userdata/ngnix-server-script.sh")

  tags = {
    Name = "${var.env_prefix}-nginx-instance"
  }
}
```
  * Here, we created two instances. One for the bastion and the other for the public instance.
  * Bastion instance: This instance will be used to connect to the private instance through ssh.
  * Public instance: This instance will be used to host our simple web-server.

![instances](/assests/instances.png)

## Create Cloud Watch Alarm

```hashicorp

resource "aws_cloudwatch_metric_alarm" "cost-optimization-alarm" {
  alarm_name          = "cost-optimization-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "21600"
  statistic           = "Maximum"
  threshold           = "0.1"

  dimensions = {
    ServiceName = "Amazon Elastic Compute Cloud - Compute",
    Currency    = "USD",
    Instance_id = var.instance_type
  }

  alarm_description = "This alarm monitors the estimated charges for Amazon EC2 instances and triggers if the cost goes above $0.01 per day."

  alarm_actions = var.alarm_action

}

```
  * This alarm will be used to monitor the estimated charges for Amazon EC2 instances and triggers if the cost goes above $0.01 per day.


# Live Server

[live link](http://3.252.28.105/)

![page](/assests/page.png)

# How to Run/Contribute

### START HERE: Initialize the instance

- Navigate to the terraform backend-state folder. `cd terraform`.
- Export your credentials:
```bash
  export AWS_ACCESS_KEY_ID="anaccesskey"
  export AWS_SECRET_ACCESS_KEY="asecretkey"
  export AWS_REGION="eu-west-1"
```
- **Pull recent state**: Run the `terraform init` command to pull the recent state from the s3 bucket

### Provisioning the instances

- **Make your changes: Update where necessary**
- **Formatting**: `terraform fmt -recursive`. This format your changes to standard
- **Plan**: Run the `terraform plan` command. This allows you see your changes that will be provisioned
- **Apply**: Run the `terraform apply` command.

### Destroy the instances

`terraform destroy`

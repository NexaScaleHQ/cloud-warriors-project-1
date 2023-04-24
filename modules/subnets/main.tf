/**
* A public subnet with in our VPC that we can launch resources into that we
* want to be auto-assigned a public ip addresses.  These resources will be
* exposed to the public internet, with public IPs, by default. They don't need
* to go through, and aren't shielded by NAT Gateway.
*/


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



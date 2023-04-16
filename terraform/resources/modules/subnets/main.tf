/**
* A public subnet with in our VPC that we can launch resources into that we
* want to be auto-assigned a public ip addresses.  These resources will be
* exposed to the public internet, with public IPs, by default. They don't need
* to go through, and aren't shielded by NAT Gateway.
*/

resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.vpc_cidr_block
  availability_zone       = var.availability_zone
  # map_public_ip_on_launch = true
  tags = {
    Name = "${var.env_prefix}-web-server-public-subnet"
  }
}

/**
* Associate the public route table with the public subnets.
*/

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.subnet.id

  route_table_id = var.route_table_id
}

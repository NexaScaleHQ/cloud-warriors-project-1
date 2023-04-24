/*** Internet Gateway - Provides a connection between the VPC and the public internet, 
allowing traffic to flow in and out of the VPC and translating IP addresses to public* addresses.*/

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env_prefix}-web-server-igw"
  }
}

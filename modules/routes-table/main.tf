/*** A route from the public route table out to the internet through the internet* gateway.*/
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

/*** Associate the public route table with the public subnets.*/
resource "aws_route_table_association" "public" {
  count          = var.public_subnets_count
  subnet_id      = element(var.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}


/*** A route from the private route table out to the internet through the NAT * Gateway.*/

resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }

  tags = {
    Name = "${var.env_prefix}-web-server-private-rt"
  }
}

/*** Associate the private route table with the private subnet.*/
resource "aws_route_table_association" "private" {
  count          = var.private_subnets_count
  subnet_id      = element(var.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private_rt.id
}

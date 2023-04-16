/**
* A route from the public route table out to the internet through the internet
* gateway.
*/

resource "aws_route_table" "web-server-rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0" // route to all network
    gateway_id = var.internet_gateway_id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = var.internet_gateway_id
  }

  tags = {
    Name = "${var.env_prefix}-web-server-rt"
  }
}

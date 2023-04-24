/*** An elastic IP address to be used by the NAT Gateway defined below. 
The NAT* gateway acts as a gateway between our private subnets and the public* internet, providing access out to the internet from within those subnets,* while denying access to them from the public internet.  This IP address* acts as the IP address from which all the outbound traffic from the private* subnets will originate.*/

resource "aws_eip" "eip_for_the_nat_gateway" {
  vpc = true

  tags = {
    Name = "${var.env_prefix}-web-server-eip-for-the-nat-gateway"
  }
}

/*** A NAT Gateway that lives in our public subnet and provides an interface* between our private subnets and the public internet.  It allows traffic to* exit our private subnets, but prevents traffic from entering them.*/

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip_for_the_nat_gateway.id
  subnet_id     = element(var.public_subnets.*.id, 0)

  tags = {
    Name = "${var.env_prefix}-web-server-nat-gateway"
  }
}

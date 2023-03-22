/**
* The internet gateway provides a connection between the VPC and the public internet, allowing
* traffic to flow in and out of the VPC and translating IP addresses to public
* addresses.
*/

resource "aws_internet_gateway" "web-server-igw" {
  vpc_id = "${var.vpc_id}"
  tags   = {
    Name = "web-server-igw"
  }
}
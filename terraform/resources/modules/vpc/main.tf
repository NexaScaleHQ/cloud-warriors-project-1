resource "aws_vpc" "main_vpc" {
  cidr_block         = var.cidr_block
  enable_dns_support = true
  # enable_dns_hostnames = true
  tags = {
    Name = "${var.env_prefix}-main_vpc"
  }
}


resource "aws_network_interface" "web-server-network-interface" {
  subnet_id       = var.subnet_id
  private_ips     = ["10.0.1.50"]
  security_groups = [var.security_groups]
}

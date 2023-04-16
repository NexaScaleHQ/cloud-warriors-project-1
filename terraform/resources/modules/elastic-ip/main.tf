resource "aws_eip" "eip" {
  vpc                       = true
  network_interface         = var.network_interface_id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [var.internet_gateway_id]
}

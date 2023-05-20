
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}
resource "tls_private_key" "infra_key" {
  algorithm = var.algorithm
}

resource "aws_key_pair" "ngnix-server-key-pair" {
  key_name   = var.key_name
  public_key = tls_private_key.infra_key.public_key_openssh
}

resource "local_file" "private_key" {
  depends_on = [
    tls_private_key.infra_key,
  ]
  content  = tls_private_key.infra_key.private_key_pem
  filename = var.filename
}

resource "aws_instance" "nginx-instance" {
  ami                    = "ami-00aa9d3df94c6c354"
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_allow_web]
  subnet_id              = element(var.public_subnets, 0).id

  user_data = file("./userdata/ngnix-server-script.sh")

  tags = {
    Name = "${var.env_prefix}-nginx-instance"
  }
}


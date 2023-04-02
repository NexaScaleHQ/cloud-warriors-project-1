
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_key_pair" "ngnix-server-key-pair" {
  key_name = "ngnix-server-key-pair"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "nginx-instance" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = "t2.micro"

  subnet_id = var.subnet_id

  vpc_security_group_ids = [
    var.security_group_id
  ]
  availability_zone       = var.availability_zone

  assocaiate_public_ip_address = true
  key_name = aws_key_pair.ngnix-server-key-pair.key_name

  user_data = file("ngnix-server-script")

  tags = {
    Name = "${var.env_prefix}=nginx-instance"
  }
}

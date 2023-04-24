/*** The public key for the key pair we'll use to ssh into our bastion instance.*/

resource "aws_key_pair" "bastion" {
  key_name   = "bastion-key"
  public_key = file(var.public_key_path)
}

/*** This parameter contains the AMI ID for the most recent Amazon Linux 2 ami,* managed by AWS.*/

data "aws_ssm_parameter" "linux2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn-ami-hvm-x86_64-ebs"
}

/*** Launch a bastion instance we can use to gain access to the private subnets of* this availabilty zone.*/

resource "aws_instance" "bastion" {
  ami                         = "ami-00aa9d3df94c6c354"
  key_name                    = aws_key_pair.bastion.key_name
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = element(var.public_subnets, 0).id
  vpc_security_group_ids      = [var.security_group_bastion_id]

  tags = {
    Name = "webserver-bastion"
  }
}


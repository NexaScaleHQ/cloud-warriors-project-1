/**
* A security group to allow HTTP, HTTPS and SSH access into web server.
*/
resource "aws_security_group" "allow-web-security-group" {
  vpc_id = "${var.vpc_id}"
  description = "Allow web inbound traffic"
  name = "allows_web_traffic"
   ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress { 
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # allow for all
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 is a special protocol that means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-web"
  }
}

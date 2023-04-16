output "ec2_public_ip" {
  value = aws_instance.nginx-instance.public_ip
}

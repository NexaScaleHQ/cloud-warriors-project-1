output "instance_ngnix" {
  value = aws_instance.nginx-instance.public_ip
}

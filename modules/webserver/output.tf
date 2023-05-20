output "instance_ngnix" {
  value = aws_instance.nginx-instance.public_ip
}
output "instance_id" {
  value = aws_instance.nginx-instance.id
}
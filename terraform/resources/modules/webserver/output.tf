output "ec2_public_id" {
  value = "${aws_instance.nginx-instance.public_id}"
}

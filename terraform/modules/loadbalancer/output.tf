output "load-balancer-ip" {
  value = aws_elb.ngnix_elb.dns_name
}

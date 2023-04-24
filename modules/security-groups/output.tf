output "security_group_allow_web" {
  value = aws_security_group.allow-web-security-group.id
}
output "security_group_lb" {
  value = aws_security_group.lb.id
}
output "security_group_bastion_id" {
  value = aws_security_group.bastion.id
}

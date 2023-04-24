variable "public_subnets" {}
variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}
variable "vpc_id" {}
variable "security_group_bastion_id" {}

variable "instance_type" {
  description = "The instance id to be monitored"
  default     = "t2.micro"
}
variable "env_prefix" {
  default = "dev"
}
variable "security_group_allow_web" {}
# change to your public key path
variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}
variable "private_subnets" {}

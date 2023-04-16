variable "instance_type" {
  description = "The instance id to be monitored"
  default     = "t2.micro"
}
# variable "subnet_id" {}
variable "availability_zone" {}
variable "env_prefix" {
  default = "dev"
}
variable "network_interface_id" {}

# change to your public key path
variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

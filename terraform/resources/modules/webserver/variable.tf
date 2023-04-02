variable  instance_type {
  description="The instance id to be monitored"
  default="t2.micro"  
}
variable "subnet_id" {}
variable "security_group_id" {}
variable "availability_zone" {}
variable "env_prefix" {
  default = "dev"
}

# change to your public key path
variable "public_key_path" {
  default = "/c/Users/Destiny Erhabor/.ssh/id_rsa.pub"
}
variable "private_key_path" {
  default = "/c/Users/Destiny Erhabor/.ssh/id_rsa"
}

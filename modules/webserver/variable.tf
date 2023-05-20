variable "instance_type" {
  description = "The instance id to be monitored"
  default     = "t2.micro"
}
variable "env_prefix" {
  default = "dev"
}
variable "security_group_allow_web" {}
# change to your public key path
variable "algorithm" {
  type        = string
  default     = "RSA"
  description = "Algorithm"
}
variable "key_name" {
  type        = string
  default     = "ngnix-server-key"
  description = "ngnix-server-key"
}

variable "filename" {
  type        = string
  default     = "ngnix-server-key.pem"
  description = "private key"
}

variable "public_subnets" {}

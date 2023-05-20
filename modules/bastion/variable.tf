variable "public_subnets" {}
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
variable "vpc_id" {}
variable "security_group_bastion_id" {}

variable "public_subnets" {}
variable "algorithm" {
  type        = string
  default     = "RSA"
  description = "Algorithm"
}
variable "key_name" {
  type        = string
  default     = "bastion"
  description = "bastion"
}

variable "filename" {
  type        = string
  default     = "bastion.pem"
  description = "private key"
}
variable "vpc_id" {}
variable "security_group_bastion_id" {}

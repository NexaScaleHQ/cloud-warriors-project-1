variable "vpc_id" {}
variable "vpc_cidr_block" {}
variable "env_prefix" {
  default = "dev"
}
variable "private_subnets_count" {
  default = 2
}
variable "public_subnets_count" {
  default = 2
}
variable "availability_zones" {}

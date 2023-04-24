variable "vpc_id" {}
variable "internet_gateway_id" {}
variable "env_prefix" {
  default = "dev"
}
variable "public_subnets" {}
variable "private_subnets" {}
variable "nat_gateway_id" {}
variable "public_subnets_count" {
  default = 2
}
variable "private_subnets_count" {
  default = 2
}

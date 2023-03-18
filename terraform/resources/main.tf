provider "aws" {}

terraform {
  backend "s3" {
    bucket  = "nginx-web-server-backend-state"
    key     = "web-server/development/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

# Import modules
module "vpc" {
  source = "./modules/vpc"
}
module "internet-gateway" {
  source = "./modules/internet-gateway"
  vpc_id = "${module.vpc.vpc_id}"
}
module "route-table" {
  source = "./modules/route-table"
  vpc_id = "${module.vpc.vpc_id}" 
  internet_gateway_id = "${module.internet-gateway.internet_gateway_id}"
}
module "subnet" {
  source = "./modules/subnet"
  vpc_id = "${module.vpc.vpc_id}"
  cidr_block = "${module.vpc.vpc_cidr_block}"
  route_table_id = "${module.route-table.route_table_id}"
}
module "security-groups" {
  source = "./modules/security-group"
  vpc_id = "${module.vpc.vpc_id}"
}

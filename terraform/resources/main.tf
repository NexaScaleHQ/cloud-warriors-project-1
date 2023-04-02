provider "aws" {
  region     = "eu-west"
  access_key = var.aws_access_key 
  secret_key = var.aws_secret_key 
}
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
  vpc_id = module.vpc.vpc_id
}
module "route-table" {
  source              = "./modules/routes-table"
  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.internet-gateway.internet_gateway_id
}
module "subnet" {
  source            = "./modules/subnets"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = module.vpc.vpc_cidr_block
  route_table_id    = module.route-table.route_table_id
  availability_zone = var.availability_zone
}
module "security-groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

module "webserver" {
  source            = "./modules/webserver"
  subnet_id         = module.subnet.public_subnets_id
  security_group_id = module.security-groups.webserver_security_group_id
  availability_zone = var.availability_zone
}

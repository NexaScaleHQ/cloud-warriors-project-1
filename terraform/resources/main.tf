provider "aws" {}

terraform {
  backend "s3" {
    bucket  = "team-warriors-web-server-backend-state"
    key     = "team-warriors-web-server/development/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
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
  vpc_cidr_block    = module.vpc.vpc_cidr_block
  route_table_id    = module.route-table.route_table_id
  availability_zone = var.availability_zone
}
module "security-groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
}
module "network-interface" {
  source          = "./modules/network-interface"
  subnet_id       = module.subnet.subnet_id
  security_groups = module.security-groups.security_group_id
}
module "elastic-ip" {
  source               = "./modules/elastic-ip"
  internet_gateway_id  = module.internet-gateway.internet_gateway_id
  network_interface_id = module.network-interface.network_interface_id
}
module "webserver" {
  source               = "./modules/webserver"
  # subnet_id            = module.subnet.public_subnet_id
  network_interface_id = module.network-interface.network_interface_id
  availability_zone    = var.availability_zone
}

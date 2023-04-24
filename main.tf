

# Import modules
module "vpc" {
  source = "./modules/vpc"
}
module "subnet" {
  source             = "./modules/subnets"
  vpc_id             = module.vpc.vpc_id
  vpc_cidr_block     = module.vpc.vpc_cidr_block
  availability_zones = var.availability_zones
}
module "internet-gateway" {
  source = "./modules/internet-gateway"
  vpc_id = module.vpc.vpc_id
}
module "nat-gateway" {
  source         = "./modules/nat-gateway"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.subnet.public_subnets
}
module "route-table" {
  source              = "./modules/routes-table"
  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.internet-gateway.internet_gateway_id
  public_subnets      = module.subnet.public_subnets
  private_subnets     = module.subnet.private_subnets
  nat_gateway_id      = module.nat-gateway.nat_gateway_id
}
module "security-groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
}
module "bastion" {
  source                    = "./modules/bastion"
  public_subnets            = module.subnet.public_subnets
  vpc_id                    = module.vpc.vpc_id
  security_group_bastion_id = module.security-groups.security_group_bastion_id
}
module "webserver" {
  source                   = "./modules/webserver"
  public_subnets           = module.subnet.public_subnets
  security_group_allow_web = module.security-groups.security_group_allow_web
}
module "loadbalancer" {
  source            = "./modules/loadbalancer"
  instance_ngnix    = module.webserver.instance_ngnix
  security_group_lb = module.security-groups.security_group_lb
  public_subnets    = module.subnet.public_subnets
  vpc_id            = module.vpc.vpc_id
}

# module "alarm" {
#   source = "./modules/alarm"
# }

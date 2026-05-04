provider "aws" {
  region = "eu-west-3"
}

module "network" {
  source = "./modules/network"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}

module "eks" {
  source = "./modules/eks"

  public_subnet_1_id  = module.network.public_subnet_1_id
  public_subnet_2_id  = module.network.public_subnet_2_id
  private_subnet_1_id = module.network.private_subnet_1_id
  private_subnet_2_id = module.network.private_subnet_2_id
}

module "compute" {
  source = "./modules/compute"

  public_subnet_1_id = module.network.public_subnet_1_id
  security_group_id  = module.security.security_group_id
}

module "ecr" {
  source = "./modules/ecr"
}

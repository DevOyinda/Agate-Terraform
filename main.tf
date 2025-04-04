# VPC
module "vpc" {
  source = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
  vpc_id               = module.vpc.vpc_id
}

# EC2 Instance
module "ec2" {
  source               = "./modules/ec2"
  ami_id               = var.ami_id
  ec2_instance_type    = var.ec2_instance_type
  key_name             = var.key_name
  security_group_ids   = [module.vpc.security_group_id]  # Wrap single SG in a list
  vpc_id               = module.vpc.vpc_id
  public_subnets       = module.vpc.public_subnets
  azs                  = var.azs
}

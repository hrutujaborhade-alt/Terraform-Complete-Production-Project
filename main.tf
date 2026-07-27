module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr

  name_prefix = local.prefix

  common_tags = local.common_tags

  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs

}

module "security-groups" {
  source = "./modules/security-groups"

  vpc_id = module.vpc.vpc_id

  name_prefix = local.prefix

  common_tags = local.common_tags

}

module "iam" {
  source = "./modules/iam"

  name_prefix = local.prefix
  common_tags = local.common_tags
}

module "ec2" {
  source = "./modules/ec2"
  
}

resource "aws_instance" "test" {
  ami = "ami-06067086cf86c58e6"
  instance_type = "t3.micro"

  subnet_id = module.vpc.public_subnet_ids[0]
}
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

module "launch-template" {
  source = "./modules/launch-template"

  name_prefix = local.prefix
  common_tags = local.common_tags

  ami_id        = var.ami_id
  instance_type = var.instance_type

  ec2_security_group_id = module.security-groups.ec2_sg_id

  instance_profile_name = module.iam.instance_profile_name
}

module "alb" {
  source = "./modules/alb"

  name_prefix = local.prefix
  common_tags = local.common_tags

  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security-groups.alb_sg_id


}

module "autoscaling" {
  source = "./modules/autoscaling"

  name_prefix = local.prefix
  common_tags = local.common_tags

  launch_template_id = module.launch-template.launch_template_id
  private_subnet_ids = module.vpc.private_app_subnet_ids
  target_group_arn   = module.alb.target_group_arn
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  name_prefix = local.prefix
  common_tags = local.common_tags

  notification_mail = var.notification_mail
  asg_name          = module.autoscaling.asg_name
}

module "rds" {
  source = "./modules/rds"

  name_prefix = local.prefix
  common_tags = local.common_tags

  db_name = var.db_name

  db_subnet_ids         = module.vpc.private_db_subnet_ids
  db_security_group_ids = module.security-groups.rds_sg_id

  db_password = var.db_password
}


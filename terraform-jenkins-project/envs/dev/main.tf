terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }

  backend "s3" {
    bucket         = "myapp-tfstate-957948932374"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "myapp-tfstate-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
  default_tags { tags = local.common_tags }
}

locals {
  env  = "dev"
  name = "${var.project_name}-${local.env}"
  common_tags = {
    Project     = var.project_name
    Environment = local.env
    ManagedBy   = "Terraform"
  }
}

module "vpc" {
  source = "../../../modules/vpc"

  name               = local.name
  vpc_cidr           = var.vpc_cidr
  azs                = var.azs
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  enable_nat_gateway = false   # save cost in dev
  tags               = local.common_tags
}

module "s3_assets" {
  source = "../../../modules/s3"

  bucket_name   = "${local.name}-assets-${data.aws_caller_identity.current.account_id}"
  versioning    = false
  force_destroy = true
  tags          = local.common_tags
}

module "rds" {
  source = "../../../modules/rds"

  name               = local.name
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  app_sg_ids         = [module.ec2.ec2_sg_id]
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  instance_class     = "db.t3.micro"
  multi_az           = false
  deletion_protection = false
  skip_final_snapshot = true
  tags               = local.common_tags
}

module "ec2" {
  source = "../../../modules/ec2"

  name             = local.name
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.private_subnet_ids
  alb_sg_ids       = []
  target_group_arns = []
  instance_type    = var.instance_type
  min_size         = 1
  max_size         = 2
  desired_capacity = 1
  tags             = local.common_tags
}

data "aws_caller_identity" "current" {}

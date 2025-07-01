terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "networking" {
  source       = "../../modules/networking"
  project_name = var.project_name
}

module "security" {
  source       = "../../modules/security"
  project_name = var.project_name
  vpc_id       = module.networking.vpc_id
}

module "compute" {
  source        = "../../modules/compute"
  project_name  = var.project_name
  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  web_subnet_id = module.networking.public_subnet_id
  app_subnet_id = module.networking.private_app_subnet_id
  db_subnet_id  = module.networking.private_db_subnet_id
  web_sg_id     = module.security.web_sg_id
  app_sg_id     = module.security.app_sg_id
  db_sg_id      = module.security.db_sg_id
}
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

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  az                  = var.az
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}

module "db" {
  source            = "./modules/db"
  subnet_id         = module.vpc.private_subnet_id
  security_group_id = module.security.db_sg_id
  key_name          = var.key_name
}

module "app" {
  source            = "./modules/app"
  subnet_id         = module.vpc.private_subnet_id
  security_group_id = module.security.app_sg_id
  db_host           = module.db.db_endpoint
  key_name          = var.key_name
}

module "web" {
  source            = "./modules/web"
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security.web_sg_id
  app_host          = module.app.app_private_ip
  key_name          = var.key_name
}

output "web_public_ip" {
  value = module.web.public_ip
}

output "db_private_ip" {
  value = module.db.db_endpoint
}

output "app_private_ip" {
  value = module.app.app_private_ip
}

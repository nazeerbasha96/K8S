terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
  bucket = "urotaxi1.0-tfstate-bucket"
  region = "ap-south-1"
  key = "terraform.tfstate"
  dynamodb_table = "urotaxi-terraform-lock"
}
}



provider "aws" {
  region = "ap-south-1"

}
module "k8s_vpc" {
  source   = "../Module/Vpc"
  vpc_cidr = var.Vpc_block.vpc_cidr
  vpc_name = var.Vpc_block.vpc_name
}
module "k8s_public_subnet" {
  source            = "../Module/Subnet"
  vpc_id            = module.k8s_vpc.vpc_id
  count             = length(var.public_subnet_block.public_cidr)
  public_cidr       = element(var.public_subnet_block.public_cidr, count.index)
  public_name       = "${var.public_subnet_block.public_name}_${count.index}"
  availability_zone = element(var.public_subnet_block.availability_zone, count.index)

}

module "k8s_ig" {
  source      = "../Module/IG"
  vpc_id      = module.k8s_vpc.vpc_id
  public_id   = [module.k8s_public_subnet[0].public_id, module.k8s_public_subnet[1].public_id]
  k8s_ig_name = var.ig_block.k8s_ig_name
  k8s_rt_name = var.ig_block.k8s_rt_name
}


module "eks_cluster" {
  source          = "../Module/Eks"
  cluster_version = "1.27"
  subnet_id       = module.k8s_public_subnet[*].public_id
  cluster_name    = var.eks_cluster_name

}
module "eks_role" {
  source           = "../Module/Eks/node_group"
  eks_cluster_name = var.eks_cluster_name
  subnet_id        = module.k8s_public_subnet[*].public_id
  depends_on       = [module.eks_cluster]
}

module "db_server" {
  source            = "../Module/rds"
  vpc_id            = module.k8s_vpc.vpc_id
  db_cidr           = [var.Vpc_block.vpc_cidr]
  allocated_storage = var.db_server.allocated_storage
  db_name           = var.db_server.db_name
  db_username       = var.db_server.db_username
  db_password       = var.db_server.db_password
  instance_class    = var.db_server.instance_class
  subnet_id         = [module.k8s_public_subnet[0].public_id,module.k8s_public_subnet[1].public_id]

}

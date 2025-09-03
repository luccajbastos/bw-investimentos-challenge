locals {
    name = "${var.name}-${local.env}-${data.aws_region.current.id}"
    region = data.aws_region.current.id
    env = terraform.workspace == "default" ? "dev" : terraform.workspace

  azs             = slice(data.aws_availability_zones.azs.names, 0, lookup(var.vpc, local.env)["number_azs"])
  cidr            = lookup(var.vpc, local.env)["cidr"]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.cidr, 4, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.cidr, 4, k + 3)]
  data_subnets    = [for k, v in local.azs : cidrsubnet(local.cidr, 4, k + 6)]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = "${local.name}-vpc"
  azs  = local.azs
  cidr = local.cidr

  private_subnets  = local.private_subnets
  public_subnets   = local.public_subnets
  database_subnets = local.data_subnets

  database_subnet_group_name = "${local.name}-db-subnet-group"

  enable_nat_gateway = lookup(var.vpc, local.env)["enable_nat"]
  single_nat_gateway = lookup(var.vpc, local.env)["single_nat"]

}

module "eks" {
    source = "./modules/eks"
    depends_on = [ module.vpc ]

    name = local.name
    eks_public_endpoint = local.env == "dev" ? true : false

    network = {
        vpc_id = module.vpc.vpc_id
        cluster_subnet_ids = local.env == "dev" ? module.vpc.public_subnets : module.vpc.private_subnets
        nodes_subnet_ids = local.env == "dev" ? module.vpc.public_subnets : module.vpc.private_subnets
    }

}

module "aws-alb-controller" {
  depends_on = [ module.eks ]
  source = "./modules/alb-controller-helm"

  aws_region = local.region
  eks_cluster_id = module.eks.cluster_name
  eks_cluster_endpoint = module.eks.cluster_endpoint 
  eks_cluster_ca = module.eks.cluster_ca
  eks_vpc_id = module.vpc.vpc_id
}


output "cluster_endpoint" {
    value = module.eks.cluster_endpoint
}

output "vpc_public_subnets" {
  value = module.vpc.public_subnets
}

output "alb_security_group" {
  value = module.eks.alb_sg
}
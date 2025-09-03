output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "alb_sg" {
  value = aws_security_group.alb_sg.id
}

output "cluster_ca" {
  value = module.eks.cluster_certificate_authority_data
}
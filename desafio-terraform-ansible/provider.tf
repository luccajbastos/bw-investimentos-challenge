provider "aws" {
    region = "us-east-1"
}

provider "helm" {
    kubernetes = {
        host                   = module.eks.cluster_endpoint
        cluster_ca_certificate = base64decode(module.eks.cluster_ca)
        token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
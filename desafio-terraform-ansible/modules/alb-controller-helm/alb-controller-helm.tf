resource "helm_release" "aws_lb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.13.0"

  # Não cria a ServiceAccount, usa a existente
  set = [{
    name  = "clusterName"
    value = var.eks_cluster_id
  },
  {
    name  = "serviceAccount.create"
    value = "false"
  },
  {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  },
  {
    name  = "vpcId"
    value = var.eks_vpc_id
  }]

  depends_on = [
    null_resource.aws_lb_controller_sa 
  ]
}

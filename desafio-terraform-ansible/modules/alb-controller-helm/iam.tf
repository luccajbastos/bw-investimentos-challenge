resource "aws_iam_policy" "AWSLoadBalancerControllerIAMPolicy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "AWSLoadBalancerControllerIAMPolicy"

  policy = file("${path.module}/policy.json")
}

resource "null_resource" "aws_lb_controller_sa" {
  provisioner "local-exec" {
    command = <<EOT
      eksctl create iamserviceaccount \
        --cluster=${var.eks_cluster_id} \
        --namespace=kube-system \
        --name=aws-load-balancer-controller \
        --attach-policy-arn=${aws_iam_policy.AWSLoadBalancerControllerIAMPolicy.arn} \
        --override-existing-serviceaccounts \
        --region=${var.aws_region} \
        --approve
    EOT
    environment = {
      AWS_DEFAULT_REGION = var.aws_region
    }
  }

  # Garante que só execute depois do cluster e nodes estarem criados
  depends_on = [
    aws_iam_policy.AWSLoadBalancerControllerIAMPolicy
  ]
}

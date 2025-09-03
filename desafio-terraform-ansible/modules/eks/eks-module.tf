module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.1.5"

  name               = "${var.name}-eks"
  kubernetes_version = var.eks_version

  enable_cluster_creator_admin_permissions = true
  authentication_mode = "API_AND_CONFIG_MAP"

  addons = {
    coredns                = {
      before_compute = false
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }

  enable_kms_key_rotation = false
  create_kms_key = true

  endpoint_public_access = var.eks_public_endpoint
  vpc_id     = var.network.vpc_id
  control_plane_subnet_ids = var.network.cluster_subnet_ids
  security_group_id = aws_security_group.sg_cluster.id
  node_security_group_id = aws_security_group.nodes_sg.id

}

module "eks_managed_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"

  name            = "default-np"
  cluster_name    = module.eks.cluster_name
  cluster_service_cidr = module.eks.cluster_service_cidr
  subnet_ids = var.network.nodes_subnet_ids

  network_interfaces = [
    {
      associate_public_ip_address = true
    }
  ]

  min_size     = 1
  max_size     = 3
  desired_size = 3

  instance_types = ["m6i.large", "m7i.large"]
  capacity_type  = "SPOT"

}
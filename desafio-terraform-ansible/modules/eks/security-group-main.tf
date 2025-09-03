resource "aws_security_group" "sg_cluster" {
  name        = "${var.name}-cluster-sg"
  description = "Security Group for EKS Cluster"
  vpc_id      = var.network.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow Kubernetes API traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
        "Name"                   = "${var.name}-cluster-sg"
  }
}

resource "aws_security_group" "nodes_sg" {
  name        = "${var.name}-nodes-sg"
  description = "Security Group for EKS Nodes"
  vpc_id      = var.network.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"                   = "${var.name}-nodes-sg"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.name}-alb-sg"
  description = "Security Group for ALB"
  vpc_id      = var.network.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"                   = "${var.name}-alb-sg"
  }
}
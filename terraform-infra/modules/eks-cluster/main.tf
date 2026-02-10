# modules/eks-cluster/main.tf

# --- EKS Cluster Security Group ---
resource "aws_security_group" "eks_cluster_sg" {
  # Use the VPC ID passed from the Root module
  vpc_id      = var.vpc_id 
  description = "Security group for EKS control plane"

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-cluster-sg"
  }
}

# --- EKS Cluster Definition ---
resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  version  = "1.30"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    # Use the Subnet IDs passed from the Root module
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  # Ensure IAM roles are created before cluster creation
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_service_policy
  ]

  tags = {
    Name = var.cluster_name
  }
}
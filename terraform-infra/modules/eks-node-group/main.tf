# modules/eks-node-group/main.tf

# --- EKS Managed Node Group ---
resource "aws_eks_node_group" "workers" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-workers"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  # Uses instance type passed from root (t2.micro to save quota)
  instance_types = [var.instance_type]

  scaling_config {
    min_size     = var.min_size
    max_size     = var.max_size
    desired_size = var.desired_size
  }

  capacity_type = "ON_DEMAND"
  disk_size     = 20

  labels = {
    role = "worker"
  }

  tags = {
    Name = "${var.cluster_name}-node-group"
  }
}

# --- Persistent Storage (EBS Volume) ---
resource "aws_ebs_volume" "postgres_volume" {
  availability_zone = "${var.region}a" 
  size              = 5
  type              = "gp3"

  tags = {
    Name = "postgres-ebs-volume"
  }
}
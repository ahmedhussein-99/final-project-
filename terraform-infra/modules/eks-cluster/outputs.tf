# modules/eks-cluster/outputs.tf

output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "cluster_oidc_issuer_url" {
  value = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

# This output is used by the Node Group module in root main.tf
output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

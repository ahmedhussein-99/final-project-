# modules/eks-cluster/variables.tf

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID passed from the central VPC module"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs passed from the central VPC module"
  type        = list(string)
}
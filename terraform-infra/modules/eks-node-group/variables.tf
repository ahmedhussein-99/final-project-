# modules/eks-node-group/variables.tf

variable "cluster_name" {
  description = "Name of the existing EKS cluster"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of the IAM role for EKS worker nodes"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs where nodes will run"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1 # Reduced to bypass quota limits
}

variable "max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 1 # Reduced to bypass quota limits
}

variable "desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 1 # Reduced to bypass quota limits
}

variable "instance_type" {
  description = "EC2 instance type for nodes"
  type        = string
  default     = "t2.micro" # Changed from t3.medium to t2.micro to fix Fleet Quota error
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
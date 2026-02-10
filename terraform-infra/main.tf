# ===================================================================
# 1. TERRAFORM & PROVIDER CONFIGURATION
# ===================================================================
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# ===================================================================
# 2. NETWORK INFRASTRUCTURE (VPC)
# ===================================================================
module "vpc" {
  source = "./modules/vpc"
}

# ===================================================================
# 3. SECURITY & CONTAINER REGISTRY (ECR, KMS, SECRETS)
# ===================================================================
module "ecr" {
  source = "./modules/ecr"
}

module "security" {
  source = "./modules/security"
}

# ===================================================================
# 4. COMPUTE & ORCHESTRATION (EKS)
# ===================================================================
module "eks_cluster" {
  source       = "./modules/eks-cluster"
  cluster_name = "ayman-eks"
  region       = "us-east-1"
  
  # Link EKS to the central VPC module
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids 
}

module "eks_nodes" {
  source        = "./modules/eks-node-group"
  cluster_name  = module.eks_cluster.cluster_name
  
  # FIX: Match the output name defined in modules/eks-cluster/outputs.tf
  # This role allows EC2 instances to join the cluster as worker nodes.
  node_role_arn = module.eks_cluster.eks_node_role_arn 
  
  subnet_ids    = module.vpc.private_subnet_ids
  
  # These parameters define the managed node group size and instance type
  min_size      = 1
  max_size      = 1
  desired_size  = 1
  instance_type = "t2.micro" # Using t2.micro to stay within free tier/quota limits
  region        = "us-east-1"
}

# ===================================================================
# 5. DATA LAYER (RDS POSTGRESQL & ELASTICACHE REDIS)
# ===================================================================
module "rds" {
  source             = "./modules/rds"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "redis" {
  source             = "./modules/redis"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

# ===================================================================
# 6. IAM ROLES FOR SERVICE ACCOUNTS (IRSA)
# ===================================================================
data "aws_caller_identity" "current" {}

# ===================================================================
# 7. INFRASTRUCTURE OUTPUTS
# ===================================================================
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster control plane"
  value       = module.eks_cluster.cluster_endpoint
}

output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = module.rds.rds_endpoint
}

output "redis_endpoint" {
  description = "The connection endpoint for the Redis cluster"
  value       = module.redis.redis_endpoint
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = module.eks_cluster.cluster_oidc_issuer_url
}
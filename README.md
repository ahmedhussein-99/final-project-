# 🚀 Full-Stack EKS Cluster with RDS, Redis, and ECR — Terraform

A production-ready Terraform implementation for deploying a complete Amazon EKS cluster with fully integrated data and caching layers, following AWS best practices for security, networking, and high availability.

## 📦 What's Included

### ✅ Core Infrastructure
- **EKS Control Plane** (v1.30) with public/private endpoint access
- **Managed Node Group** (t2.micro optimized for quota compliance)
- **VPC Network** with public/private subnets across multiple AZs
- **NAT Gateway** for secure outbound connectivity

### ✅ Data Layer
- **Amazon RDS** - PostgreSQL database with private subnet isolation
- **Amazon ElastiCache** - Redis cluster for caching
- **Amazon ECR** - Private container registry for Docker images

### ✅ Security & Compliance
- **Centralized Security Module** for IAM, KMS, and security groups
- **Least-privilege IAM roles** for cluster, nodes, and services
- **Network Isolation** - All data services run in private subnets
- **Security Group Rules** - Strict inbound/outbound controls

## 🏗️ Architecture

### Network Topology
```
VPC (10.0.0.0/16)
├── Public Subnets (10.0.1.0/24, 10.0.2.0/24)
│   └── NAT Gateway + Internet Gateway
├── Private Subnets (10.0.3.0/24, 10.0.4.0/24)
│   ├── EKS Worker Nodes
│   ├── RDS PostgreSQL
│   └── ElastiCache Redis
└── VPC Endpoints (ECR, S3, etc.)
```

### Security Model
- **EKS Nodes** → Can access RDS (5432) and Redis (6379)
- **Public Internet** → Can access EKS API endpoint only
- **No Public IPs** on data layer resources
- **All traffic** encrypted in transit and at rest

## 📁 Project Structure

```
.
├── main.tf                 # Root module orchestrating all components
├── outputs.tf              # Infrastructure outputs
├── variables.tf            # Configuration variables
├── terraform.tfvars        # Variable definitions
└── modules/
    ├── vpc/                # Networking foundation
    ├── eks-cluster/        # EKS control plane
    ├── eks-node-group/     # Managed worker nodes
    ├── ecr/                # Container registry
    ├── rds/                # PostgreSQL database
    ├── redis/              # ElastiCache Redis
    └── security/           # IAM, KMS, Security Groups
```

## 🚀 Quick Start

### Prerequisites
- AWS CLI configured (`aws configure`)
- Terraform v1.6+
- kubectl installed
- AWS IAM permissions for EKS, RDS, ElastiCache

### Deployment Steps

1. **Initialize Terraform**
```bash
terraform init
```

2. **Review the Plan**
```bash
terraform plan
```

3. **Deploy Infrastructure** (takes ~15 minutes)
```bash
terraform apply --auto-approve
```

4. **Configure kubectl**
```bash
aws eks update-kubeconfig \
  --name ayman-eks \
  --region us-east-1
```

5. **Verify Deployment**
```bash
kubectl get nodes
terraform output
```

## 🔐 IAM Roles & Permissions

### EKS Cluster Role (`*-cluster-role`)
- **Purpose**: EKS control plane management
- **Policies**: `AmazonEKSClusterPolicy`, `AmazonEKSServicePolicy`

### EKS Node Role (`*-node-role`)
- **Purpose**: Worker node operations
- **Policies**:
  - `AmazonEKSWorkerNodePolicy` - Cluster membership
  - `AmazonEKS_CNI_Policy` - Pod networking
  - `AmazonEC2ContainerRegistryReadOnly` - ECR access
  - `AmazonEBSCSIDriverPolicy` - Storage volumes

## 🛡️ Security Configuration

### Security Groups
| Resource | Port | Source | Purpose |
|----------|------|--------|---------|
| RDS | 5432 | Node SG | PostgreSQL access |
| Redis | 6379 | Node SG | Redis cache access |
| EKS API | 443 | 0.0.0.0/0 | Kubernetes API |

### Network Security
- **Private Subnets**: All data services (RDS, Redis, Nodes)
- **Public Subnets**: NAT Gateway, Load Balancers only
- **No SSH Access**: Managed nodes without bastion host
- **Encryption**: KMS for secrets, TLS for all communications

## 📊 Outputs

After deployment, you'll get:
- `eks_cluster_endpoint` - Kubernetes API URL
- `rds_endpoint` - PostgreSQL connection string
- `redis_endpoint` - Redis cluster endpoint
- `ecr_repository_url` - Container registry URL
- `vpc_id` - Network identifier

## 🧪 Validation Checklist

- [ ] `kubectl get nodes` shows all nodes in `Ready` state
- [ ] ECR repository created and accessible
- [ ] RDS instance status is `Available`
- [ ] Redis cluster is `Available`
- [ ] OIDC provider linked for IRSA
- [ ] Security groups enforcing correct rules
- [ ] NAT Gateway providing outbound internet

## 🧹 Cleanup

To destroy all resources and avoid charges:
```bash
terraform destroy
```

## 📚 Best Practices Implemented

| Practice | Implementation |
|----------|----------------|
| **Network Isolation** | Private subnets for all data services |
| **Least Privilege** | Minimal IAM roles with specific policies |
| **High Availability** | Multi-AZ deployment for all components |
| **Cost Optimization** | t2.micro instances, managed services |
| **Security** | No public IPs, encrypted data, strict SG rules |
| **Modularity** | 8 reusable Terraform modules |
| **GitOps Ready** | ECR integrated, ready for CI/CD pipelines |

## 🔄 Maintenance

### Scaling
- **Nodes**: Update `desired_size` in node group
- **RDS**: Modify instance class or storage
- **Redis**: Adjust node type or shards

### Updates
- **Kubernetes**: Use `eks-cluster` module version
- **Terraform**: Regular `terraform apply` for drift detection
- **Security**: Rotate KMS keys, update IAM policies

## 🆘 Troubleshooting

### Common Issues

1. **Nodes Not Joining Cluster**
   - Check IAM role permissions
   - Verify subnet routing tables
   - Review node security groups

2. **RDS Connection Failures**
   - Validate security group rules
   - Check VPC endpoint connectivity
   - Verify database credentials

3. **Terraform Timeouts**
   - Increase timeout values in variables
   - Check AWS service limits
   - Verify network connectivity

## 📄 License

Apache 2.0 - See LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Push to the branch
5. Open a Pull Request

---
**Note**: This is a production-grade template. Modify variables in `terraform.tfvars` for your specific requirements. Always review `terraform plan` before applying changes to production environments.

**Estimated Cost**: ~$50-100/month (depending on usage and region)
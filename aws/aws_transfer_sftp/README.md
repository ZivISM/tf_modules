# AWS Transfer Family (SFTP) Infrastructure

This repository contains Terraform configurations for deploying a secure SFTP server using AWS Transfer Family, integrated with S3 storage and Route53 DNS management.

## 🏗 Architecture Overview

The infrastructure consists of:
- AWS Transfer Family SFTP Server
- S3 Bucket for SFTP storage
- VPC with private subnets (optional)
- Route53 DNS management
- ACM Certificate for secure transfers

## 📋 Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- Domain registered in AWS Route53 (if using DNS features)
- AWS account with appropriate permissions

## 🚀 Quick Start

1. Clone this repository
2. Update the variables in `main.tf`
3. Initialize and apply:

```bash
terraform init
terraform apply
```

## 🔧 Configuration Options

### Required Variables
| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| `project` | Project name | `string` | - |
| `aws_region` | AWS region | `string` | - |
| `transfer_server_name` | SFTP server name | `string` | - |
| `s3_bucket_name` | S3 bucket name | `string` | - |
| `sftp_username` | SFTP username | `string` | - |

### VPC Configuration
| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| `use_vpc` | Enable VPC usage | `bool` | `true` |
| `create_vpc` | Create new VPC | `bool` | `true` |
| `vpc_cidr` | VPC CIDR block | `string` | `"10.0.0.0/16"` |
| `num_zones` | Number of availability zones | `number` | `2` |

### DNS Configuration
| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| `create_hosted_zone` | Create Route53 zone | `bool` | `false` |
| `domain_name` | Domain name | `string` | `null` |
| `auto_renew` | Auto-renew domain | `bool` | `true` |

## 🔍 Infrastructure Validation

### For VPC-based SFTP servers:

1. **Connect from within the VPC**
   - Use an EC2 instance in the same VPC as a bastion/jump host
   - Install SFTP client on the EC2 instance:
   ```bash
   # On Amazon Linux
   sudo yum install -y openssh-clients
   
   # Test SFTP connection
   sftp username@VPC-endpoint
   ```

2. **Test using AWS CLI from within VPC**
   ```bash
   # Check if endpoint is reachable
   aws transfer test-connection-status \
     --server-id s-xxxx \
     --region your-region
   
   # List SFTP users
   aws transfer list-users --server-id s-xxxx
   ```

3. **VPC Endpoint Verification**
   ```bash
   # Check VPC endpoints
   aws ec2 describe-vpc-endpoints \
     --filters Name=vpc-id,Values=vpc-xxx
   ```

### For Public SFTP servers:
```

## 🛡️ Security Features

- VPC endpoint isolation (when VPC is enabled)
- IAM role-based access control
- S3 bucket encryption
- SFTP protocol security
- DNS security with Route53

## 📝 Notes

- DNS propagation may take up to 48 hours
- VPC endpoints enable private communication
- S3 bucket names must be globally unique
- SFTP users are managed through IAM roles

## 🚨 Common Issues

1. **Connection Issues**
   - Verify security group rules
   - Check VPC endpoint configuration
   - Confirm IAM permissions

2. **DNS Problems**
   - Verify Route53 record creation
   - Check domain ownership
   - Allow time for DNS propagation

3. **S3 Access**
   - Verify IAM role permissions
   - Check S3 bucket policy
   - Confirm SFTP user home directory configuration


## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.



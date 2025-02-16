## 🏗 Detailed Architecture

### 1. DNS Layer (Route53)
- **Options:**
  - Create new hosted zone (`create_hosted_zone = true`)
    - Manages domain: `domain_name`
    - Auto-renewal settings: `auto_renew`
    - Cleanup settings: `force_destroy`
  - Use existing hosted zone (`create_hosted_zone = false`)
    - References existing zone via `route53_record_zone`

### 2. Network Layer (VPC)
- **Options:**
  - Public Mode (`use_vpc = false`)
    - SFTP server accessible from internet
    - Simplified architecture
    - Direct S3 access
  
  - VPC Mode (`use_vpc = true`)
    - **New VPC** (`create_vpc = true`)
      - Custom CIDR: `vpc_cidr`
      - Multi-AZ: `num_zones`
      - NAT Gateway options:
        - `enable_nat_gateway`
        - `single_nat_gateway`
    
    - **Existing VPC** (`create_vpc = false`)
      - Uses: `existing_vpc_id`
      - Uses: `existing_subnet_ids`

### 3. SFTP Server (AWS Transfer Family)
- Server Configuration:
  - Name: `transfer_server_name`
  - Region: `aws_region`
  - Identity Provider: IAM
  - Protocol: SFTP

- User Configuration:
  - Username: `sftp_username`
  - Home Directory: `sftp_home_directory`
  - IAM Role for S3 access

### 4. Storage Layer (S3)
- Bucket Configuration:
  - Name: `s3_bucket_name`
  - Encryption: AWS-managed keys
  - Access:
    - Private access only
    - Access via SFTP user roles
    - VPC endpoint (if in VPC mode)

### 5. Security Components
- **IAM Roles & Policies:**
  - SFTP service role
  - User-specific roles
  - S3 access policies

- **VPC Endpoints** (when `use_vpc = true`):
  - Transfer endpoint
  - S3 endpoint
  - Additional endpoints via `additional_allowed_endpoints`

### 6. Data Flow
1. **Client Connection:**
   ```
   SFTP Client → Route53 DNS → Transfer Family Server
   ```

2. **Authentication:**
   ```
   Transfer Server → IAM Authentication → User Validation
   ```

3. **File Operations:**
   ```
   SFTP Commands → Transfer Server → S3 Bucket
   ```

### 7. High Availability
- Multi-AZ deployment when using VPC
- AWS-managed service reliability
- S3 durability: 99.999999999%

### 8. Monitoring & Logging
- CloudWatch metrics
- Transfer Family logs
- S3 access logs
- VPC flow logs (when using VPC)

### 9. Cost Components
- Transfer Family usage
- S3 storage and requests
- VPC endpoints (if used)
- NAT Gateway (if enabled)
- Route53 hosted zone

### 10. Scaling Considerations
- Automatic scaling of Transfer Family
- S3 unlimited storage
- VPC subnet sizing
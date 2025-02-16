# Insert variables here for a full sftp server, s3 bucket, route53
module "sftp_transfer" {
  source = "./modules"

  ###############################################################################
  # Required Configuration
  ###############################################################################
  project              = "zivoosh-testing"    # Required: Project name
  aws_region          = "us-east-1"     # Required: AWS region
  transfer_server_name = "zivoosh-testing-sftp-server"   # Required: Name for the SFTP server
  s3_bucket_name      = "zivoosh-testing-s3-bucket"     # Required: S3 bucket name for SFTP storage
  sftp_username       = "zivoosh-testing-sftp-user"     # Required: SFTP user name
  tags = {
    Project = "zivoosh-testing"
  }
  ###############################################################################
  # VPC Configuration
  ###############################################################################
  use_vpc    = false    # Required: Whether to use VPC (true/false)
  create_vpc = false    # Required: Whether to create new VPC (true/false)

  # Required if create_vpc = true
  vpc_cidr            = "10.0.0.0/16"
  num_zones           = 2
  enable_nat_gateway  = true
  single_nat_gateway  = true

  # Required if create_vpc = false
  existing_vpc_id     = null     # Set VPC ID if create_vpc = false
  existing_subnet_ids = null     # Set subnet IDs if create_vpc = false

  ###############################################################################
  # Route53 Configuration (Optional)
  ###############################################################################
  create_hosted_zone  = true               # Whether to create Route53 hosted zone
  domain_name         = "zivoosh.xyz"      # Required if create_hosted_zone = true
  auto_renew         = false               # Required if create_hosted_zone = true
  force_destroy      = true               # Required if create_hosted_zone = true
  route53_record_zone_id = null   # Required if create_hosted_zone = false
  
  ###############################################################################
  # SFTP Configuration
  ###############################################################################
  sftp_home_directory = "/home/sftp-user"  # Optional: Defaults to /home

  ###############################################################################
  # Additional VPC Endpoints (Optional)
  ###############################################################################
  additional_allowed_endpoints = {
    # Add more endpoints as needed, example:
    # ecr_api = {
    #   service             = "ecr.api"
    #   private_dns_enabled = true
    # }
  }
}

# Insert variables here for a full sftp server, s3 bucket, route53
module "sftp_transfer" {
  source = "./modules"

  # Project Configuration
  project              = 
  transfer_server_name = 
  s3_bucket_name       = 
  aws_region           = 

  # VPC Configuration
  use_vpc    = 
  create_vpc =   # Set to false if using existing VPC
  vpc_cidr   = 
  num_zones  = 
  single_nat_gateway = 
  enable_nat_gateway = 
  
  # Only needed if create_vpc = false
  existing_vpc_id = null
  
  domain_name         = 
  auto_renew          = 
  force_destroy       = 
  route53_record_zone = 

  sftp_username       = 
  sftp_home_directory = 

  additional_allowed_endpoints = {
    # Add more endpoints as needed
  }
}

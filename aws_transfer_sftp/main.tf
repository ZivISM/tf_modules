# Insert variables here for a full sftp server, s3 bucket, route53
module "sftp_transfer" {
  source = "./modules/transfer_server"
###############################################################################
# General
###############################################################################
  project              = 
  transfer_server_name =    
  s3_bucket_name       =    

###############################################################################
# Route53
###############################################################################
  domain_name         = 
  auto_renew         = 
  force_destroy      = 
  route53_record_zone = 
  alb_name           = 

###############################################################################
# Transfer Server
############################################################################### 
  sftp_username      = 
  sftp_home_directory = 
}

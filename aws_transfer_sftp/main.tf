# Insert variables here for a full sftp server, s3 bucket, route53, and iam.check "name" {
# The module does not create an alb, so you need to create an alb and pass the name to the module.

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
# IAM
############################################################################### 
  sftp_username      = 
  sftp_home_directory = 
}

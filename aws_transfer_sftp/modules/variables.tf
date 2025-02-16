###############################################################################
# General
###############################################################################
variable "project" {
  type = string
  description = "The project name"
}

variable "aws_region" {
  type = string
  description = "The AWS region"
}


###############################################################################
# Transfer Server 
###############################################################################
variable "transfer_server_name" {
  type = string
  description = "The transfer server name"
}

variable "sftp_username" {
  description = "Username for SFTP access"
  type        = string
}

variable "sftp_home_directory" {
  description = "Home directory path in the S3 bucket"
  type        = string
  default     = "/home"
}

variable "s3_bucket_name" {
  type = string
  description = "The S3 bucket name"
}

###############################################################################
# Route53
###############################################################################
variable "domain_name" {
  description = "Domain name for the SFTP endpoint"
  type        = string
} 

variable "auto_renew" {
  type = bool
  description = "Whether to auto renew the domain"
}

variable "force_destroy" {
  type = bool
  description = "Whether to force destroy the Route53 zone"
}

variable "route53_record_zone" {
  type = string
  description = "The Route53 zone ID"
}

variable "alb_name" {
  type = string
  description = "The ALB name"
}

###############################################################################
# Route53 Domain Registration
###############################################################################
variable "domain_contact" {
  description = "Domain registration contact details"
  type = object({
    first_name          = string
    last_name           = string
    email               = string
    phone_number        = string
    address_line_1      = string
    city                = string
    state               = string
    country_code        = string
    zip_code            = string
  })
}

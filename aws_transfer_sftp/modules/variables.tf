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

variable "use_vpc" {
  type        = bool
  description = "Whether to deploy the SFTP server in a VPC"
  default     = false
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

###############################################################################
# VPC configuration
###############################################################################
variable "create_vpc" {
  type        = bool
  description = "Whether to create a new VPC"
  default     = false
}

variable "existing_vpc_id" {
  type        = string
  description = "Existing VPC ID if not creating a new one"
  default     = null
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC if creating a new one"
  default     = "10.0.0.0/16"
}

variable "num_zones" {
  description = "The number of availability zones to use"
  type        = number
}

variable "single_nat_gateway" {
  description = "Whether to use a single NAT gateway"
  type        = bool
}

variable "enable_nat_gateway" {
  description = "Whether to enable NAT gateways"
  type        = bool
}

variable "additional_allowed_endpoints" {
  description = "Map of VPC endpoint configurations"
  type = map(object({
    service             = string
    service_type        = optional(string, "Interface")
    subnet_ids          = optional(list(string))
    private_dns_enabled = optional(bool, true)
    route_table_ids     = optional(list(string))
  }))
  default = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = []
    }
    transfer = {
      service             = "transfer.server"
      private_dns_enabled = true
      subnet_ids          = []
    }
  }
}

variable "existing_subnet_ids" {
  type        = list(string)
  description = "List of existing subnet IDs if not creating a new VPC"
  default     = []
}


###############################################################################
# VPC
###############################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.0"
  
  # Only create VPC if create_vpc is true
  count = var.create_vpc ? 1 : 0

  name = "${var.project}-vpc"
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 48)]
  intra_subnets   = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 52)]

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

data "aws_availability_zones" "available" {
  # Exclude local zones
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}


locals {
  # VPC ID based on whether we're creating or using existing
  vpc_id = var.create_vpc ? module.vpc[0].vpc_id : var.existing_vpc_id
  
  # Subnets based on whether we're creating or using existing
  private_subnets = var.create_vpc ? module.vpc[0].private_subnets : var.existing_subnet_ids
  
  azs = slice(data.aws_availability_zones.available.names, 0, var.num_zones)
}


###############################################################################
# VPC Endpoints (Only if VPC is created)
###############################################################################
module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  
  count = var.create_vpc ? 1 : 0

  vpc_id = local.vpc_id

  # Reference security group with index when it exists
  security_group_ids = var.use_vpc ? [aws_security_group.sftp[0].id] : []

  endpoints = local.vpc_endpoints

  tags = merge(
    local.tags,
    {
      Name = "${var.project}-vpc-endpoints"
    }
  )

  depends_on = [module.vpc]
}
###############################################################################
# VPC Locals
###############################################################################
locals {
  subnet_ids = var.create_vpc ? module.vpc[0].private_subnets : []
}

###############################################################################
# VPC Endpoints
###############################################################################
locals {
  # Base endpoints that are always included
  base_endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = var.create_vpc ? module.vpc[0].private_route_table_ids : []
    }
    transfer = {
      service             = "transfer.server"
      service_type        = "Interface"
      subnet_ids          = var.create_vpc ? module.vpc[0].private_subnets : var.existing_subnet_ids
      private_dns_enabled = true
    }
  }

  # Merge base endpoints with any additional endpoints
  vpc_endpoints = merge(local.base_endpoints, var.additional_allowed_endpoints)
}

###############################################################################
# Tags
###############################################################################
locals {
  tags = merge(var.tags, {
    Project = var.project
  })
}

###############################################################################
# Security Group CIDRs
###############################################################################
locals {
  # Define CIDR blocks based on VPC usage
  security_group_cidrs = var.use_vpc ? (
    try(module.vpc[0].private_subnets_cidr_blocks, [var.vpc_cidr])
  ) : ["0.0.0.0/0"]
}
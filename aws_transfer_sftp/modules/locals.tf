###############################################################################
# VPC Locals
###############################################################################
locals {
  vpc_id = var.create_vpc ? module.vpc[0].vpc_id : var.existing_vpc_id
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
      route_table_ids = module.vpc.private_route_table_ids
    }
    transfer = {
      service             = "transfer.server"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    }
  }

  # Merge base endpoints with user-provided endpoints if any exist
  vpc_endpoints = length(var.additional_allowed_endpoints) > 0 ? merge(local.base_endpoints, var.additional_allowed_endpoints) : local.base_endpoints
}
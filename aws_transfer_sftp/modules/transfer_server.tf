###############################################################################
# Transfer Server
###############################################################################
resource "aws_transfer_server" "sftp" {
  identity_provider_type = "SERVICE_MANAGED"
  protocols             = ["SFTP"]
  domain               = "S3"
  endpoint_type        = var.use_vpc ? "VPC" : "PUBLIC"
  
  endpoint_details {
    address_allocation_ids = var.use_vpc ? null : []  # Empty list for regional endpoint
    vpc_id                 = var.use_vpc ? local.vpc_id : null
    subnet_ids             = var.use_vpc ? local.subnet_ids : null
    security_group_ids     = var.use_vpc ? [aws_security_group.sftp[0].id] : null
  }

  tags = {
    Name    = var.transfer_server_name
    Project = var.project
  }
}

###############################################################################
# Transfer User
###############################################################################
resource "aws_transfer_user" "sftp_users" {
  for_each = toset(var.sftp_users)

  server_id = aws_transfer_server.sftp.id
  user_name = each.value
  role      = aws_iam_role.transfer_server_role.arn

  home_directory_type = "LOGICAL"
  home_directory_mappings {
    entry  = "/"
    target = "/${module.s3_bucket.s3_bucket_id}/home/${each.value}"
  }

  tags = merge(
    local.tags,
    {
      Name = "${var.transfer_server_name}-user-${each.value}"
    }
  )
  
  depends_on = [ aws_transfer_server.sftp ]
}

###############################################################################
# Security Group (VPC only)
###############################################################################


resource "aws_security_group" "sftp" {
  count = var.use_vpc ? 1 : 0

  name        = "${var.transfer_server_name}-sg"
  description = "Security group for SFTP server"
  vpc_id      = local.vpc_id

  ingress {
    description = "SFTP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.security_group_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.tags,
    {
      Name = "${var.transfer_server_name}-sg"
    }
  )
}
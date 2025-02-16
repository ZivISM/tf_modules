###############################################################################
# Route53 Zone (Optional)
###############################################################################
resource "aws_route53_zone" "main" {
  # Only create if use_vpc is true and create_hosted_zone is true
  count = var.use_vpc && var.create_hosted_zone ? 1 : 0
  
  name = var.domain_name
  force_destroy = var.force_destroy

  # VPC association for private hosted zone
  dynamic "vpc" {
    for_each = var.use_vpc ? [1] : []
    content {
      vpc_id = local.vpc_id
    }
  }

  tags = {
    Name    = var.domain_name
    Project = var.project
  }
}

###############################################################################
# Route53 Records (Optional)
###############################################################################
resource "aws_route53_record" "sftp" {
  # Only create if use_vpc is true and create_hosted_zone is true
  count = var.use_vpc && var.create_hosted_zone ? 1 : 0

  zone_id = aws_route53_zone.main[0].zone_id
  name    = "sftp.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_transfer_server.sftp.endpoint]
}

resource "aws_api_gateway_domain_name" "sftp" {
  domain_name              = "sftp.${var.domain_name}"

  regional_certificate_arn = module.acm[0].acm_certificate_arn
  security_policy         = "TLS_1_2"
  
  tags = {
    Name    = "sftp.${var.domain_name}"
    Project = var.project
  }
}

###############################################################################
# ACM Certificate (Optional)
###############################################################################
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  count = var.use_vpc && var.create_hosted_zone ? 1 : 0

  domain_name = var.domain_name
  zone_id    = aws_route53_zone.main[0].zone_id
  
  validation_method = "DNS"
  subject_alternative_names = ["*.${var.domain_name}"]
  wait_for_validation = false

  tags = {
    Name      = var.domain_name
    Project   = var.project
    Terraform = "true"
  }
}


###############################################################################
# Route53 Zone
###############################################################################
resource "aws_route53_zone" "main" {
  name = var.domain_name
  force_destroy = var.force_destroy

  # VPC association if using VPC endpoint
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
# Route53 Records
###############################################################################
resource "aws_route53_record" "sftp" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "sftp.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_transfer_server.sftp.endpoint]
}

resource "aws_api_gateway_domain_name" "sftp" {
  domain_name              = "sftp.${var.domain_name}"
  regional_domain_name     = "sftp.${var.domain_name}"
  regional_certificate_arn = module.acm.acm_certificate_arn
  security_policy         = "TLS_1_3"
  
  tags = {
    Name    = "sftp.${var.domain_name}"
    Project = var.project
  }
}

###############################################################################
# ACM Certificate
###############################################################################
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = var.domain_name
  zone_id    = aws_route53_zone.main.zone_id

  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain_name}",
  ]

  wait_for_validation = false

  tags = {
    Name        = var.domain_name
    Project     = var.project
    Terraform   = "true"
  }

  depends_on = [aws_route53_zone.main]
}


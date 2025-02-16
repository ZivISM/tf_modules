###############################################################################
# Route53 Zone
###############################################################################
resource "aws_route53_zone" "main" {
  name = var.domain_name

  force_destroy = var.force_destroy

  tags = {
    Name = var.domain_name
    Project = var.project
  }
}

###############################################################################
# Route53 Domain Registration
###############################################################################
resource "aws_route53domains_registered_domain" "main" {
  domain_name = var.domain_name
  auto_renew  = var.auto_renew

  registrant_contact {
    first_name        = var.domain_contact.first_name
    last_name         = var.domain_contact.last_name
    email            = var.domain_contact.email
    phone_number     = var.domain_contact.phone_number
    address_line_1   = var.domain_contact.address_line_1
    city            = var.domain_contact.city
    state           = var.domain_contact.state
    country_code    = var.domain_contact.country_code
    zip_code        = var.domain_contact.zip_code
  }

  dynamic "name_server" {
    for_each = aws_route53_zone.main.name_servers
    content {
      name = name_server.value
    }
  }

  tags = {
    Name    = var.domain_name
    Project = var.project
  }

  depends_on = [aws_route53_zone.main]
}

###############################################################################
# Route53 Records
###############################################################################
resource "aws_route53_record" "sftp" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "sftp.${var.domain_name}"
  type    = "A"

  alias {
    name                   = data.aws_alb.alb.dns_name
    zone_id               = data.aws_alb.alb.zone_id
    evaluate_target_health = true
  }

  depends_on = [aws_route53_zone.main]
}

data "aws_alb" "alb" {
  name = var.alb_name

  depends_on = [aws_route53_zone.main]
}

###############################################################################
# ACM
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
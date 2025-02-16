resource "aws_transfer_server" "sftp" {
  identity_provider_type = "SERVICE_MANAGED"
  protocols              = ["SFTP"]
  endpoint_type          = "PUBLIC"
  domain                 = "S3"  
  
  tags = {
    Name = "${var.project}-${var.transfer_server_name}"
  }

  depends_on = [aws_route53_zone.main]
}

resource "aws_transfer_user" "sftp_user" {
  server_id = aws_transfer_server.sftp.id
  user_name = var.sftp_username
  role      = aws_iam_role.transfer_server_role.arn

  home_directory_type = "LOGICAL"

  home_directory_mappings {
    entry  = "/"
    target = "/${module.s3_bucket.s3_bucket_id}${var.sftp_home_directory}"
  }
}
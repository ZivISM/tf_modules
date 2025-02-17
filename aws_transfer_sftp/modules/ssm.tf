###############################################################################
# SSM Configuration
###############################################################################
resource "aws_ssm_parameter" "sftp_endpoint" {
  name  = "/${var.project}/sftp/endpoint"
  type  = "String"
  value = aws_transfer_server.sftp.endpoint
}

resource "aws_ssm_parameter" "sftp_users" {
  name  = "/${var.project}/sftp/users"
  type  = "String"
  value = jsonencode(var.sftp_users)
} 
output "sftp_endpoint" {
  description = "SFTP server endpoint"
  value       = aws_transfer_server.sftp.endpoint
}

output "sftp_server_id" {
  description = "SFTP server ID"
  value       = aws_transfer_server.sftp.id
}

output "s3_bucket_id" {
  description = "S3 bucket ID"
  value       = module.s3_bucket.s3_bucket_id
}
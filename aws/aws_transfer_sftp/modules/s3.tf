module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.project}-${var.s3_bucket_name}"

  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"
  
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }


  versioning = {
    enabled = true
  }

  tags = {
    Name = "${var.project}-${var.s3_bucket_name}"
    Project = var.project
  }
}

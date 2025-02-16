module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.project}-${var.s3_bucket_name}"

  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  versioning = {
    enabled = true
  }

  tags = {
    Name = "${var.project}-${var.s3_bucket_name}"
    Project = var.project
  }
}


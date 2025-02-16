resource "aws_iam_role" "transfer_server_role" {
  name = "${var.project}-transfer-server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "transfer.amazonaws.com"
        }
      }
    ]
  })

  depends_on = [ aws_iam_role.transfer_server_policy ]
}

resource "aws_iam_role_policy" "transfer_server_policy" {
  name = "${var.project}-transfer-server-policy"
  role = aws_iam_role.transfer_server_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowListingOfUserFolder"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          module.s3_bucket.s3_bucket_arn
        ]
      },
      {
        Sid    = "HomeDirObjectAccess"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${module.s3_bucket.s3_bucket_arn}/*"
        ]
      }
    ]
  })

  depends_on = [ module.s3_bucket ]
}
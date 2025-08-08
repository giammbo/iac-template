resource "aws_s3_bucket" "dr_region" {
  provider = aws.dr_region
  bucket = "${var.namespace}-${var.project_name}-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.id}"
}

resource "aws_s3_bucket_versioning" "dr_region" {
  provider = aws.dr_region
  bucket = aws_s3_bucket.dr_region.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "dr_region" {
  provider = aws.dr_region
  bucket = aws_s3_bucket.dr_region.id

  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipalGet"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.dr_region.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "${aws_cloudfront_distribution.main.arn}"
          }
        }
      },
      {
        Sid       = "AllowCloudFrontServicePrincipalList"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:ListBucket"
        Resource = "${aws_s3_bucket.dr_region.arn}"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "${aws_cloudfront_distribution.main.arn}"
          }
        }
      }
    ]
  })
}
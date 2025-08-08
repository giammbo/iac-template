resource "aws_s3_bucket_replication_configuration" "replication" {
  depends_on        = [
    aws_s3_bucket_versioning.main,
    aws_s3_bucket_versioning.dr_region,
  ]

  role              = aws_iam_role.replication.arn
  bucket            = aws_s3_bucket.main.id

  rule {
    id = "replica-to-dr"

    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.dr_region.arn
    }
  }
}
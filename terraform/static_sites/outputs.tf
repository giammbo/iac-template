output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.main.id
}

output "s3_bucket_name" {
  description = "Primary S3 bucket name"
  value       = aws_s3_bucket.main.bucket
}

output "s3_bucket_dr_name" {
  description = "DR S3 bucket name"
  value       = aws_s3_bucket.dr_region.bucket
}

output "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = aws_cloudfront_distribution.main.arn
}

output "s3_bucket_arn" {
  description = "Primary S3 bucket ARN"
  value       = aws_s3_bucket.main.arn
}

output "s3_bucket_dr_arn" {
  description = "DR S3 bucket ARN"
  value       = aws_s3_bucket.dr_region.arn
}

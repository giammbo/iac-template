# AWS Static Sites Terraform Module

A comprehensive Terraform module for deploying static websites on AWS with CloudFront distribution, S3 storage, and disaster recovery capabilities.

## Features

- **CloudFront Distribution**: Global content delivery with failover support
- **S3 Storage**: Primary and disaster recovery buckets with versioning
- **Cross-Region Replication**: Automatic replication between primary and DR regions
- **Custom Domain Support**: Route53 integration with SSL certificates
- **SSL Certificate Management**: Optional automatic SSL certificate creation
- **Security**: Origin Access Control (OAC) for secure S3 access
- **Logging**: CloudFront access logs to S3
- **Lambda@Edge Support**: Optional Lambda function associations
- **Error Handling**: Custom error responses for SPA routing

## Module Structure

The module consists of the following files:

- `acm.tf` - SSL certificate creation and management
- `cloudfront.tf` - CloudFront distribution configuration
- `data.tf` - Data sources for current and DR regions
- `dr_iam.tf` - IAM roles and policies for cross-region replication
- `dr_replication.tf` - S3 cross-region replication configuration
- `dr_s3.tf` - Disaster recovery S3 bucket
- `outputs.tf` - Module outputs
- `providers.tf` - AWS provider configuration
- `route53.tf` - Route53 DNS records and certificate validation
- `s3.tf` - Primary S3 bucket configuration
- `variables.tf` - Input variables
- `versions.tf` - Terraform and provider version requirements

## Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Route53 DNS   │───▶│  CloudFront CDN  │───▶│   S3 Primary    │
│                 │    │                  │    │   (eu-west-1)   │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │   S3 DR Bucket  │
                       │  (eu-central-1) │
                       └─────────────────┘
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.11.4 |
| aws | >= 5.74 |

## Prerequisites

Before using this module, ensure you have:

1. **AWS Account**: Active AWS account with appropriate permissions
2. **Route53 Hosted Zone**: Existing hosted zone for your domain
3. **S3 Logging Bucket**: S3 bucket for CloudFront access logs
4. **AWS Credentials**: Configured AWS credentials or IAM role
5. **Domain Ownership**: Ownership of the domains you want to use

## Providers

| Name | Version | Purpose |
|------|---------|---------|
| aws | >= 5.74 | Primary region (eu-west-1) |
| aws.dr_region | >= 5.74 | Disaster recovery region (eu-central-1) |
| aws.us-east-1 | >= 5.74 | SSL certificates and Lambda@Edge (us-east-1) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_name | Name of the project | `string` | n/a | yes |
| namespace | Namespace for resource naming | `string` | n/a | yes |
| certificate_arn | ACM certificate ARN for HTTPS (required if create_ssl_certificate = false) | `string` | `null` | no |
| create_ssl_certificate | Whether to create SSL certificate automatically | `bool` | `true` | no |
| s3_bucket_logs | S3 bucket for CloudFront logs | `string` | n/a | yes |
| domain_aliases | List of domain aliases for CloudFront | `list(string)` | n/a | yes |
| route_53_id | Route53 hosted zone ID | `string` | n/a | yes |
| lambda_edge | Lambda@Edge function associations | `list(object({lambda_arn = string, event_type = string}))` | `[]` | no |
| response_headers_policy_id | CloudFront response headers policy ID | `string` | `"eaab4381-ed33-4a86-88ca-d9558dc6cd63"` | no |
| origin_request_policy_id | CloudFront origin request policy ID | `string` | `"88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"` | no |
| cache_policy_id | CloudFront cache policy ID | `string` | `"658327ea-f89d-4fab-a63d-7e88639e58f6"` | no |
| default_root_object | Default root object for SPA routing | `string` | `"index.html"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cloudfront_distribution_id | CloudFront distribution ID |
| s3_bucket_name | Primary S3 bucket name |
| s3_bucket_dr_name | DR S3 bucket name |
| cloudfront_distribution_arn | CloudFront distribution ARN |
| s3_bucket_arn | Primary S3 bucket ARN |
| s3_bucket_dr_arn | DR S3 bucket ARN |

## Usage

### Basic Example with Auto-Generated SSL Certificate

```hcl
module "static_site" {
  source = "./terraform/static_sites"

  project_name    = "my-website"
  namespace       = "prod"
  s3_bucket_logs  = "my-logs-bucket"
  domain_aliases  = ["www.example.com", "example.com"]
  route_53_id     = "Z1234567890ABC"
  
  # SSL certificate will be created automatically
  create_ssl_certificate = true
}
```

### Example with Existing SSL Certificate

```hcl
module "static_site" {
  source = "./terraform/static_sites"

  project_name    = "my-website"
  namespace       = "prod"
  certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/xxx"
  s3_bucket_logs  = "my-logs-bucket"
  domain_aliases  = ["www.example.com", "example.com"]
  route_53_id     = "Z1234567890ABC"
  
  # Use existing certificate
  create_ssl_certificate = false
}
```

### Advanced Example with Lambda@Edge

```hcl
module "static_site" {
  source = "./terraform/static_sites"

  project_name    = "my-spa"
  namespace       = "prod"
  s3_bucket_logs  = "my-logs-bucket"
  domain_aliases  = ["app.example.com"]
  route_53_id     = "Z1234567890ABC"
  
  lambda_edge = [
    {
      lambda_arn = "arn:aws:lambda:us-east-1:123456789012:function:my-edge-function:1"
      event_type = "viewer-request"
    }
  ]
}
```

## Resource Naming Convention

The module follows a consistent naming convention:

- **S3 Buckets**: `{namespace}-{project_name}-{account_id}-{region}`
- **CloudFront**: `{namespace}-{project_name}`
- **IAM Roles**: `{namespace}-{project_name}-dr-s3-replication`
- **SSL Certificates**: Auto-generated with domain validation

## Security Features

- **Origin Access Control (OAC)**: Replaces legacy OAI for secure S3 access
- **HTTPS Only**: Enforces TLS 1.2+ with redirect from HTTP
- **Geographic Restrictions**: Configurable geo-blocking (default: none)
- **Private S3 Buckets**: Only accessible via CloudFront
- **SSL Certificate Management**: Automatic certificate creation and validation

## Disaster Recovery

The module implements a robust DR strategy:

1. **Cross-Region Replication**: Automatic replication from primary to DR region
2. **Failover Support**: CloudFront origin group with automatic failover
3. **Versioning**: Enabled on both primary and DR buckets
4. **IAM Roles**: Dedicated replication role with minimal permissions

## SSL Certificate Management

The module supports two SSL certificate scenarios:

### Auto-Generated Certificates (Default)

- Automatically creates ACM certificates in `us-east-1` region
- Handles DNS validation automatically
- Creates Route53 validation records
- Requires `create_ssl_certificate = true` (default)

### Existing Certificates

- Use pre-existing ACM certificates
- Requires `certificate_arn` to be provided
- Set `create_ssl_certificate = false`

## Monitoring and Logging

- **CloudFront Access Logs**: Stored in S3 with configurable prefix
- **S3 Replication Metrics**: Available via CloudWatch
- **CloudFront Metrics**: Standard CloudFront monitoring

## Cost Optimization

- **Price Class**: Uses `PriceClass_All` for global distribution
- **Compression**: Enabled for better performance and cost savings
- **Cache Policies**: Optimized default policies for static content

## Cost Considerations

This module creates the following billable AWS resources:

- **CloudFront Distribution**: Pay-per-request pricing
- **S3 Buckets**: Storage and request costs
- **S3 Replication**: Data transfer costs between regions
- **Route53**: Hosted zone and DNS query costs
- **ACM Certificates**: Free for public certificates
- **Lambda@Edge**: Per-request pricing (if used)

Estimated monthly costs for a typical static site:
- Low traffic (< 1GB/month): $1-5
- Medium traffic (10GB/month): $10-20
- High traffic (100GB/month): $50-100

*Costs may vary based on region, traffic patterns, and data transfer.*

## Limitations

- Lambda@Edge functions must be in `us-east-1` region
- DR region is hardcoded to `eu-central-1`
- SSL certificates are created in `us-east-1` region (CloudFront requirement)
- Domain validation requires Route53 hosted zone access

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Support

For issues and questions, please open an issue on GitHub.

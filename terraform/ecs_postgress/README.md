# AWS ECS PostgreSQL Terraform Module

A comprehensive Terraform module for deploying containerized applications on AWS ECS with PostgreSQL RDS database, Application Load Balancer, and comprehensive security features.

## Features

- **ECS Fargate Cluster**: Serverless container orchestration with auto-scaling
- **PostgreSQL RDS**: Managed database with encryption, backups, and performance insights
- **Application Load Balancer**: HTTPS-enabled load balancer with health checks
- **ECR Repository**: Container image registry with KMS encryption
- **Auto-scaling**: CPU and memory-based scaling policies
- **Security**: KMS encryption, IAM roles, and security groups
- **Logging**: CloudWatch log groups with configurable retention
- **ECS Exec**: Secure shell access to running containers
- **Monitoring**: Enhanced monitoring and container insights

## Module Structure

The module consists of the following files:

- `alb.tf` - Application Load Balancer configuration
- `asg.tf` - Auto-scaling policies and targets
- `cloudwatch.tf` - CloudWatch log groups configuration
- `data.tf` - Data sources for current region and account
- `ecr.tf` - ECR repository configuration
- `ecs.tf` - ECS cluster, service, and task definition
- `iam_execution_role.tf` - ECS execution role and policies
- `iam_task_role.tf` - ECS task role and policies
- `kms.tf` - KMS key for encryption
- `locals.tf` - Local variables and mappings
- `outputs.tf` - Module outputs
- `providers.tf` - AWS provider configuration
- `rds.tf` - RDS PostgreSQL instance configuration
- `sg.tf` - Security groups for ALB, app, and database
- `variables.tf` - Input variables
- `versions.tf` - Terraform and provider version requirements

## Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Internet      │───▶│   ALB (HTTPS)    │───▶│   ECS Service   │
│                 │    │                  │    │   (Fargate)     │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                ┌ ──────────────────┘    │
                                │                        ▼
                                │              ┌─────────────────┐
                                │              │   PostgreSQL    │
                                │              │     RDS         │
                                │              └─────────────────┘
                                ▼
                       ┌─────────────────┐
                       │   ECR Repo      │
                       │   (Container    │
                       │    Images)      │
                       └─────────────────┘
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.11.4 |
| aws | >= 6.8.0 |

## Prerequisites

Before using this module, ensure you have:

1. **AWS Account**: Active AWS account with appropriate permissions
2. **VPC and Subnets**: Existing VPC with public and private subnets
3. **S3 Logging Bucket**: S3 bucket for ALB access logs
4. **SSL Certificate**: ACM certificate for HTTPS termination
5. **AWS Credentials**: Configured AWS credentials or IAM role
6. **Container Image**: Docker image ready for deployment

## Providers

| Name | Version | Purpose |
|------|---------|---------|
| aws | >= 6.8.0 | Primary region (eu-west-1) |
| aws.us-east-1 | >= 6.8.0 | SSL certificates (us-east-1) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application_cloudwatch_logs_retention_days | The number of days to retain application CloudWatch logs | `number` | `7` | no |
| domain | The domain name for the application | `string` | n/a | yes |
| ecs_autoscaling_capacity | The capacity for the autoscaling ECS service i.e. [min instance running, max instance running] | `list(number)` | `[1, 2]` | no |
| exec_cloudwatch_logs_retention_days | The number of days to retain ECS exec CloudWatch logs | `number` | `7` | no |
| namespace | The namespace for the ECS service and related resources | `string` | n/a | yes |
| private_nat_subnets | The private NAT ids subnets list for the container | `list(string)` | n/a | yes |
| private_subnets | The private ids subnets list for the database | `list(string)` | n/a | yes |
| project_name | The name of the project for resource naming and tagging | `string` | n/a | yes |
| public_subnets | The public ids subnets list for ALB | `list(string)` | n/a | yes |
| rds_allocated_storage | The allocated storage for the RDS instance | `number` | `22` | no |
| rds_backup_retention_days | The days to keep the RDS backups | `number` | `30` | no |
| rds_db_name | The name of the RDS database | `string` | `"test"` | no |
| rds_engine | The engine for the RDS instance | `string` | `"postgres"` | no |
| rds_engine_version | The engine version for the RDS instance | `string` | `"17.4"` | no |
| rds_instance_class | The instance class for the RDS instance | `string` | `"db.t4g.medium"` | no |
| rds_administrator_username | The master username for the RDS instance | `string` | `"root"` | no |
| rds_multi_az | Whether to enable multi-AZ for the RDS instance | `bool` | `false` | no |
| s3_bucket_logs | The S3 bucket logs name | `string` | n/a | yes |
| ssl_regional_certificate_arn | The regional SSL certificate ARN for ALB | `string` | n/a | yes |
| task_resources | The CPU and memory resources for the ECS task in format [CPU units, Memory MiB] | `list(string)` | `["512", "1024"]` | no |
| vpc_id | The VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ecs_cluster_id | The ID of the ECS cluster |
| ecs_cluster_arn | The ARN of the ECS cluster |
| ecs_cluster_name | The name of the ECS cluster |
| ecs_service_id | The ID of the ECS service |
| ecs_service_arn | The ARN of the ECS service |
| ecs_service_name | The name of the ECS service |
| ecs_task_definition_arn | The ARN of the ECS task definition |
| ecs_task_definition_family | The family of the ECS task definition |
| ecr_repository_url | The URL of the ECR repository |
| ecr_repository_arn | The ARN of the ECR repository |
| ecr_repository_name | The name of the ECR repository |
| rds_instance_id | The ID of the RDS instance |
| rds_instance_arn | The ARN of the RDS instance |
| rds_instance_endpoint | The endpoint of the RDS instance |
| rds_instance_address | The address of the RDS instance |
| rds_instance_port | The port of the RDS instance |
| rds_instance_name | The name of the RDS instance |
| rds_subnet_group_name | The name of the RDS subnet group |
| rds_subnet_group_arn | The ARN of the RDS subnet group |
| load_balancer_id | The ID of the Application Load Balancer |
| load_balancer_arn | The ARN of the Application Load Balancer |
| load_balancer_dns_name | The DNS name of the Application Load Balancer |
| load_balancer_zone_id | The zone ID of the Application Load Balancer |
| target_group_arn | The ARN of the target group |
| target_group_name | The name of the target group |
| kms_key_id | The ID of the KMS key |
| kms_key_arn | The ARN of the KMS key |
| kms_key_alias | The alias of the KMS key |
| cloudwatch_log_group_application_name | The name of the application CloudWatch log group |
| cloudwatch_log_group_application_arn | The ARN of the application CloudWatch log group |
| cloudwatch_log_group_ecs_exec_name | The name of the ECS exec CloudWatch log group |
| cloudwatch_log_group_ecs_exec_arn | The ARN of the ECS exec CloudWatch log group |
| ecs_execution_role_arn | The ARN of the ECS execution role |
| ecs_execution_role_name | The name of the ECS execution role |
| ecs_task_role_arn | The ARN of the ECS task role |
| ecs_task_role_name | The name of the ECS task role |
| security_group_app_id | The ID of the application security group |
| security_group_alb_id | The ID of the ALB security group |
| security_group_database_id | The ID of the database security group |
| autoscaling_target_id | The ID of the autoscaling target |
| autoscaling_target_resource_id | The resource ID of the autoscaling target |

## Usage

### Basic Example

```hcl
module "ecs_postgres" {
  source = "./terraform/ecs_postgress"

  project_name    = "my-app"
  namespace       = "prod"
  domain          = "app.example.com"
  vpc_id          = "vpc-12345678"
  
  public_subnets  = ["subnet-12345678", "subnet-87654321"]
  private_subnets = ["subnet-11111111", "subnet-22222222"]
  private_nat_subnets = ["subnet-33333333", "subnet-44444444"]
  
  s3_bucket_logs  = "my-logs-bucket"
  ssl_regional_certificate_arn = "arn:aws:acm:eu-west-1:123456789012:certificate/xxx"
}
```

### Advanced Example with Custom RDS Configuration

```hcl
module "ecs_postgres" {
  source = "./terraform/ecs_postgress"

  project_name    = "my-production-app"
  namespace       = "prod"
  domain          = "app.example.com"
  vpc_id          = "vpc-12345678"
  
  public_subnets  = ["subnet-12345678", "subnet-87654321"]
  private_subnets = ["subnet-11111111", "subnet-22222222"]
  private_nat_subnets = ["subnet-33333333", "subnet-44444444"]
  
  s3_bucket_logs  = "my-logs-bucket"
  ssl_regional_certificate_arn = "arn:aws:acm:eu-west-1:123456789012:certificate/xxx"
  
  # Custom RDS configuration
  rds_instance_class = "db.t4g.large"
  rds_allocated_storage = 100
  rds_multi_az = true
  rds_backup_retention_days = 7
  
  # Custom ECS configuration
  ecs_autoscaling_capacity = [2, 5]
  task_resources = ["1024", "2048"]
  
  # Custom logging
  application_cloudwatch_logs_retention_days = 30
  exec_cloudwatch_logs_retention_days = 14
}
```

## Resource Naming Convention

The module follows a consistent naming convention:

- **ECS Cluster**: `{namespace}-{project_name}`
- **ECS Service**: `{namespace}-{project_name}`
- **Task Definition**: `{namespace}-{project_name}`
- **ECR Repository**: `{namespace}/{project_name}`
- **RDS Instance**: `{namespace}-{project_name}`
- **Load Balancer**: `{namespace}-{project_name}`
- **Security Groups**: `{namespace}-{project_name}-{type}`
- **IAM Roles**: `{namespace}-{project_name}-{type}-role`
- **KMS Key**: `{namespace}-{project_name}`

## Security Features

- **KMS Encryption**: All resources encrypted with customer-managed KMS keys
- **Security Groups**: Restrictive security groups for ALB, app, and database
- **IAM Roles**: Least-privilege IAM roles for ECS execution and tasks
- **HTTPS Only**: ALB configured for HTTPS with SSL termination
- **Private Subnets**: ECS tasks and RDS in private subnets
- **Secrets Management**: Database credentials managed via AWS Secrets Manager

## Auto-scaling Configuration

The module includes two auto-scaling policies:

1. **CPU-based Scaling**: Scales out when CPU utilization exceeds 60%
2. **Memory-based Scaling**: Scales out when memory utilization exceeds 70%

Scaling configuration:
- **Scale-out Cooldown**: 180 seconds
- **Scale-in Cooldown**: 60 seconds
- **Default Capacity**: 1-2 instances (configurable)

## Database Configuration

### PostgreSQL RDS Features

- **Engine**: PostgreSQL 17.4 (latest stable)
- **Instance Class**: db.t4g.medium (configurable)
- **Storage**: GP3 with encryption
- **Backups**: Configurable retention (default: 30 days)
- **Performance Insights**: Enabled with 7-day retention
- **Multi-AZ**: Configurable for high availability

### Security

- **Encryption**: Storage and performance insights encrypted with KMS
- **Network**: Placed in private subnets with security group restrictions
- **Credentials**: Managed via AWS Secrets Manager with automatic rotation

## Monitoring and Logging

### CloudWatch Logs

- **Application Logs**: Container application logs with configurable retention
- **ECS Exec Logs**: ECS exec command logs for debugging
- **ALB Access Logs**: Load balancer access logs stored in S3

### ECS Features

- **Container Insights**: Enhanced monitoring enabled
- **ECS Exec**: Secure shell access to running containers
- **Deployment Circuit Breaker**: Automatic rollback on failed deployments

## Cost Optimization

- **Fargate Spot**: Can be enabled for cost savings (not included in this module)
- **RDS Reserved Instances**: Available for production workloads
- **CloudWatch Logs**: Configurable retention to control costs
- **Auto-scaling**: Scale to zero during low traffic periods

## Cost Considerations

This module creates the following billable AWS resources:

- **ECS Fargate**: Pay-per-second pricing for CPU and memory
- **RDS PostgreSQL**: Instance hours, storage, and I/O
- **Application Load Balancer**: Per-hour and per-request pricing
- **ECR**: Storage and data transfer costs
- **CloudWatch Logs**: Ingestion and storage costs
- **KMS**: Key usage costs (minimal)

Estimated monthly costs for a typical application:
- Low traffic (< 100 requests/hour): $50-100
- Medium traffic (1000 requests/hour): $150-300
- High traffic (10000 requests/hour): $400-800

*Costs may vary based on region, traffic patterns, and resource sizing.*

## Limitations

- **Region Locked**: Currently hardcoded to eu-west-1 region
- **VPC Required**: Must be deployed in an existing VPC
- **Subnet Requirements**: Requires specific subnet types (public, private, private NAT)
- **SSL Certificate**: Must be provided externally
- **Container Image**: Must be built and pushed to ECR separately

## Deployment Process

1. **Build and Push Image**: Build Docker image and push to ECR
2. **Deploy Infrastructure**: Apply Terraform configuration
3. **Update Service**: Deploy new task definition with updated image
4. **Health Checks**: Verify ALB health checks pass
5. **DNS Update**: Point domain to ALB DNS name

## Troubleshooting

### Common Issues

1. **ECS Service Not Starting**: Check task definition, IAM roles, and security groups
2. **Health Check Failures**: Verify application health endpoint and security group rules
3. **Database Connection Issues**: Check RDS security groups and credentials
4. **ALB Timeouts**: Verify target group health checks and security group rules

### Debugging Commands

```bash
# Check ECS service status
aws ecs describe-services --cluster prod-my-app --services prod-my-app

# View container logs
aws logs tail /aws/ecs/prod/my-app/application --follow

# Execute commands in container
aws ecs execute-command --cluster prod-my-app --task <task-id> --command "/bin/bash" --interactive
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Support

For issues and questions, please open an issue on GitHub.

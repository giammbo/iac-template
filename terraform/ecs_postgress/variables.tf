variable "application_cloudwatch_logs_retention_days" {
  type    = number
  default = 7
  description = "The number of days to retain application CloudWatch logs"
}

variable "domain" {
  type = string
  description = "The domain name for the application"
}

variable "ecs_autoscaling_capacity" {
  type = list(number)
  default = [1, 2]
  description = "The capacity for the autoscaling ECS service i.e. [min instance running, max instance running]"
}

variable "exec_cloudwatch_logs_retention_days" {
  type    = number
  default = 7
  description = "The number of days to retain ECS exec CloudWatch logs"
}

variable "namespace" {
  type    = string
  nullable = false
  description = "The namespace for the ECS service and related resources"
}

variable "private_nat_subnets" {
  type = list(string)
  nullable = false
  description = "The private NAT ids subnets list for the container"
}

variable "private_subnets" {
  type = list(string)
  nullable = false
  description = "The private ids subnets list for the database"
}

variable "project_name" {
  type    = string
  nullable = false
  description = "The name of the project for resource naming and tagging"
}

variable "public_subnets" {
  type = list(string)
  nullable = false
  description = "The public ids subnets list for ALB"
}

variable "rds_allocated_storage" {
  type    = number
  default = 22
  description = "The allocated storage for the RDS instance"
}

variable "rds_backup_retention_days" {
  type    = number
  default = 30
  description = "The days to keep the RDS backups"
}

variable "rds_db_name" {
  type    = string
  default = "test"
  description = "The name of the RDS database"
}

variable "rds_engine" {
  type    = string
  default = "postgres"
  description = "The engine for the RDS instance"
}

variable "rds_engine_version" {
  type    = string
  default = "17.4"
  description = "The engine version for the RDS instance"
}

variable "rds_instance_class" {
  type    = string
  default = "db.t4g.medium"
  description = "The instance class for the RDS instance"
}

variable "rds_administrator_username" {
  type    = string
  default = "root"
  description = "The master username for the RDS instance"
}

variable "rds_multi_az" {
  type    = bool
  default = false
  description = "Whether to enable multi-AZ for the RDS instance"
}

variable "s3_bucket_logs" {
  type = string
  nullable = false
  description = "The S3 bucket logs name"
}

variable "ssl_regional_certificate_arn" {
  type = string
  nullable = false
  description = "The regional SSL certificate ARN for ALB"
}

variable "task_resources" {
  type = list(string)
  default = [ "512","1024" ]
  description = "The CPU and memory resources for the ECS task in format [CPU units, Memory MiB]"
}

variable "vpc_id" {
  type = string
  nullable = false
  description = "The VPC ID"
}
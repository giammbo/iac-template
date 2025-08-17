output "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  value       = aws_ecs_cluster.main.id
}

output "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = aws_ecs_cluster.main.arn
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_id" {
  description = "The ID of the ECS service"
  value       = aws_ecs_service.main.id
}

output "ecs_service_arn" {
  description = "The ARN of the ECS service"
  value       = aws_ecs_service.main.arn
}

output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.main.name
}

output "ecs_task_definition_arn" {
  description = "The ARN of the ECS task definition"
  value       = aws_ecs_task_definition.main.arn
}

output "ecs_task_definition_family" {
  description = "The family of the ECS task definition"
  value       = aws_ecs_task_definition.main.family
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.main.repository_url
}

output "ecr_repository_arn" {
  description = "The ARN of the ECR repository"
  value       = aws_ecr_repository.main.arn
}

output "ecr_repository_name" {
  description = "The name of the ECR repository"
  value       = aws_ecr_repository.main.name
}

output "rds_instance_id" {
  description = "The ID of the RDS instance"
  value       = aws_db_instance.main.id
}

output "rds_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.main.arn
}

output "rds_instance_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "rds_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.main.address
}

output "rds_instance_port" {
  description = "The port of the RDS instance"
  value       = aws_db_instance.main.port
}

output "rds_instance_name" {
  description = "The name of the RDS instance"
  value       = aws_db_instance.main.db_name
}

output "rds_subnet_group_name" {
  description = "The name of the RDS subnet group"
  value       = aws_db_subnet_group.main.name
}

output "rds_subnet_group_arn" {
  description = "The ARN of the RDS subnet group"
  value       = aws_db_subnet_group.main.arn
}

output "load_balancer_id" {
  description = "The ID of the Application Load Balancer"
  value       = aws_lb.main.id
}

output "load_balancer_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "load_balancer_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "load_balancer_zone_id" {
  description = "The zone ID of the Application Load Balancer"
  value       = aws_lb.main.zone_id
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.application.arn
}

output "target_group_name" {
  description = "The name of the target group"
  value       = aws_lb_target_group.application.name
}

output "kms_key_id" {
  description = "The ID of the KMS key"
  value       = aws_kms_key.main.key_id
}

output "kms_key_arn" {
  description = "The ARN of the KMS key"
  value       = aws_kms_key.main.arn
}

output "kms_key_alias" {
  description = "The alias of the KMS key"
  value       = aws_kms_alias.main.name
}

output "cloudwatch_log_group_application_name" {
  description = "The name of the application CloudWatch log group"
  value       = aws_cloudwatch_log_group.application.name
}

output "cloudwatch_log_group_application_arn" {
  description = "The ARN of the application CloudWatch log group"
  value       = aws_cloudwatch_log_group.application.arn
}

output "cloudwatch_log_group_ecs_exec_name" {
  description = "The name of the ECS exec CloudWatch log group"
  value       = aws_cloudwatch_log_group.ecs_exec.name
}

output "cloudwatch_log_group_ecs_exec_arn" {
  description = "The ARN of the ECS exec CloudWatch log group"
  value       = aws_cloudwatch_log_group.ecs_exec.arn
}

output "ecs_execution_role_arn" {
  description = "The ARN of the ECS execution role"
  value       = aws_iam_role.ecs_execution.arn
}

output "ecs_execution_role_name" {
  description = "The name of the ECS execution role"
  value       = aws_iam_role.ecs_execution.name
}

output "ecs_task_role_arn" {
  description = "The ARN of the ECS task role"
  value       = aws_iam_role.ecs_task.arn
}

output "ecs_task_role_name" {
  description = "The name of the ECS task role"
  value       = aws_iam_role.ecs_task.name
}

output "security_group_app_id" {
  description = "The ID of the application security group"
  value       = aws_security_group.app.id
}

output "security_group_alb_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "security_group_database_id" {
  description = "The ID of the database security group"
  value       = aws_security_group.database.id
}

output "autoscaling_target_id" {
  description = "The ID of the autoscaling target"
  value       = aws_appautoscaling_target.main.id
}

output "autoscaling_target_resource_id" {
  description = "The resource ID of the autoscaling target"
  value       = aws_appautoscaling_target.main.resource_id
}

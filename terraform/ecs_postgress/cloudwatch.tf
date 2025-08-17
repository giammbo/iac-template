resource "aws_cloudwatch_log_group" "application" {
  name              = "/aws/ecs/${var.namespace}/${var.project_name}/application"
  retention_in_days = var.application_cloudwatch_logs_retention_days
  kms_key_id = aws_kms_key.main.arn
}

resource "aws_cloudwatch_log_group" "ecs_exec" {
  name              = "/aws/ecs/${var.namespace}/${var.project_name}/ecs_exec"
  retention_in_days = var.exec_cloudwatch_logs_retention_days
  kms_key_id = aws_kms_key.main.arn
}
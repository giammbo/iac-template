resource "aws_iam_role" "ecs_task" {
  name = "${var.namespace}-${var.project_name}-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_default_policy" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_policy" "ecs_task_role_kms_access" {
  name = "${var.namespace}-${var.project_name}-task-kms-access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey",
        ]
        Resource = ["${aws_kms_key.main.arn}"]
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_task_role_exec_access" {
  name = "${var.namespace}-${var.project_name}-task-kms-access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
        ]
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = ["logs:DescribeLogGroups"]
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = ["logs:CreateLogStream", "logs:DescribeLogStreams", "logs:PutLogEvents"]
        Resource = ["${aws_cloudwatch_log_group.ecs_exec.arn}:*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_attach_kms" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = aws_iam_policy.ecs_task_role_kms_access.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_attach_exec" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = aws_iam_policy.ecs_task_role_exec_access.arn
}

resource "aws_iam_role" "ecs_execution" {
  name = "${var.namespace}-${var.project_name}-execution-role"

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

resource "aws_iam_role_policy_attachment" "ecs_execution_role_default_policy" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_iam_policy" "ecs_execution_role_secret_access" {
  name = "${var.namespace}-${var.project_name}-execution-ssm-access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["secretsmanager:GetSecretValue"]
        Resource = ["${aws_db_instance.main.master_user_secret[0].secret_arn}"]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKeyWithoutPlaintext"
        ]
        Resource = "${aws_kms_key.main.arn}"
      },
      {
        Effect = "Allow"
        Action = ["secretsmanager:ListSecrets"]
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_policy" "ecs_execution_role_ecr_access" {
  name = "${var.namespace}-${var.project_name}-execution-ecr-access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:ListTagsForResource",
          "ecr:DescribeRepositories",
          "ecr:ListImages"
        ]
        Resource = ["${aws_ecr_repository.main.arn}"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_attach_secrets" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = aws_iam_policy.ecs_execution_role_secret_access.arn
}

resource "aws_iam_role_policy_attachment" "ecs_execution_attach_ecr" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = aws_iam_policy.ecs_execution_role_ecr_access.arn
}

resource "aws_kms_key" "main" {
  description             = "KMS Key for ${var.project_name}"
  enable_key_rotation     = false
  policy = jsonencode({
      Version = "2012-10-17"
      Statement = concat(
        [
          {
            Sid    = "Enable IAM User Permissions"
            Effect = "Allow"
            Principal = {
              AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            }
            Action   = "kms:*"
            Resource = "*"
          },
          {
            Sid = "AllowCloudWatchLogsUseOfKey"
            Effect = "Allow"
            Principal = { Service: "logs.${data.aws_region.current.id}.amazonaws.com" }
            Action = [
              "kms:Encrypt",
              "kms:Decrypt",
              "kms:ReEncrypt*",
              "kms:GenerateDataKey*",
              "kms:DescribeKey"
            ],
            Resource: "*",
            Condition: {
              StringEquals: {
                "aws:SourceAccount": data.aws_caller_identity.current.account_id
              }
            }
          }
        ]
      )
  })
}

resource "aws_kms_alias" "main" {
  name          = "alias/${var.namespace}-${var.project_name}"
  target_key_id = aws_kms_key.main.key_id
}
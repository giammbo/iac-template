resource "aws_ecr_repository" "main" {
  name                 = "${var.namespace}/${var.project_name}"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "KMS"
    kms_key = aws_kms_key.main.arn
  }
}
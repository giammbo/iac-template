resource "aws_db_subnet_group" "main" {
  name       = "${var.namespace}-${var.project_name}"
  subnet_ids = var.private_subnets
}

resource "aws_db_instance" "main" {
  allocated_storage           = var.rds_allocated_storage
  apply_immediately           = true
  auto_minor_version_upgrade  = true
  backup_retention_period     = var.rds_backup_retention_days
  db_name                     = var.rds_db_name
  db_subnet_group_name        = aws_db_subnet_group.main.name
  deletion_protection         = true
  engine                      = var.rds_engine
  engine_version              = var.rds_engine_version
  identifier                  = "${var.namespace}-${var.project_name}"
  instance_class              = var.rds_instance_class
  kms_key_id                  = aws_kms_key.main.arn
  manage_master_user_password = true
  username                    = var.rds_administrator_username
  master_user_secret_kms_key_id = aws_kms_key.main.arn
  multi_az                    = var.rds_multi_az
  performance_insights_enabled= true
  performance_insights_kms_key_id = aws_kms_key.main.arn
  performance_insights_retention_period = 7
  skip_final_snapshot         = true
  storage_encrypted           = true
  storage_type                = "gp3"
  vpc_security_group_ids      = [aws_security_group.database.id]

  timeouts {
    create = "3h"
    delete = "3h"
    update = "3h"
  }
}
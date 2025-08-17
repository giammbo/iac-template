resource "aws_ecs_task_definition" "main" {
  family                   = "${var.namespace}-${var.project_name}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_resources[0]
  memory                   = var.task_resources[1]
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      Name      = "app"
      Image     = "${aws_ecr_repository.main.repository_url}:latest"
      Essential = true

      PortMappings = [
        {
          ContainerPort = 80
          Protocol      = "tcp"
        }
      ]

      LogConfiguration = {
        LogDriver = "awslogs"
        Options = {
          awslogs-group         = "${aws_cloudwatch_log_group.application.name}"
          awslogs-region        = "${data.aws_region.current.id}"
          awslogs-stream-prefix = "app"
        }
      }

      Environment = [
        {
          Name  = "DB_Host"
          Value = "${aws_db_instance.main.address}"
        },
        {
          Name  = "DB_Name"
          Value =  "${aws_db_instance.main.db_name}"
        }
      ]

      Secrets = [
        {
          Name      = "DB_User"
          ValueFrom = "${aws_db_instance.main.master_user_secret[0].secret_arn}:username::"
        },
        {
          Name      = "DB_Password"
          ValueFrom = "${aws_db_instance.main.master_user_secret[0].secret_arn}:password::"
        }
      ]
    }
  ])
}


resource "aws_ecs_cluster" "main" {
  name = "${var.namespace}-${var.project_name}"
  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.main.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.ecs_exec.name
      }
    }
    managed_storage_configuration {
      fargate_ephemeral_storage_kms_key_id = aws_kms_key.main.arn
    }
  }

  setting {
    name  = "containerInsights"
    value = "enhanced"
  }
}

resource "aws_ecs_service" "main" {
  name                    = "${var.namespace}-${var.project_name}"
  cluster                 = aws_ecs_cluster.main.id
  task_definition         = aws_ecs_task_definition.main.arn
  desired_count           = 1
  enable_execute_command  = true
  launch_type             = "FARGATE"
  enable_ecs_managed_tags = true
  availability_zone_rebalancing = "ENABLED"

  deployment_circuit_breaker {
    enable = true
    rollback = true
  }
  network_configuration {
    subnets          = var.private_nat_subnets
    security_groups  = [aws_security_group.app.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.application.arn
    container_name   = "app"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}
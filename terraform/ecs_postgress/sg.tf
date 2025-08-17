resource "aws_security_group" "database" {
  name        = "${var.namespace}-${var.project_name}-db"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   description = "Allow inbound traffic from the app security group"
  #   from_port   = 5432
  #   to_port     = 5432
  #   protocol    = "tcp"
  #   security_groups = [aws_security_group.app.id]
  # }
}

resource "aws_security_group" "alb" {
  name        = "${var.namespace}-${var.project_name}-alb"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow inbound traffic from the cloudfront ips"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    prefix_list_ids = [
      lookup(local.cloudfront_prefix_list_map, local.region)
    ]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app" {
  name        = "${var.namespace}-${var.project_name}$-app"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow inbound traffic from the ALB security group"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
}
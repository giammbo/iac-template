resource "aws_lb" "main" {
  name                = "${var.namespace}-${var.project_name}"
  load_balancer_type  = "application"
  security_groups     = [aws_security_group.alb.id]
  subnets             = var.public_subnets
  enable_cross_zone_load_balancing = true
  enable_zonal_shift  = true
  preserve_host_header = true
  enable_deletion_protection = true

  access_logs {
    bucket  = var.s3_bucket_logs
    prefix  = "loadbalancer/logs/${var.namespace}-${var.project_name}"
    enabled = true
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_regional_certificate_arn

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type     = "text/plain"
      message_body     = "not enabled"
      status_code      = 403
    }
  }
}

resource "aws_lb_listener_rule" "base_domain" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 99

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.application.arn
      }
    }
  }

  condition {
    host_header {
      values = [var.domain]
    }
  }
}

resource "aws_lb_target_group" "application" {
  name        = "${var.namespace}-${var.project_name}-app"
  port        = 443
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    interval            = 30
    path                = "/healthy"
    protocol            = "HTTP"
    port                = "80"
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  deregistration_delay = 30
}
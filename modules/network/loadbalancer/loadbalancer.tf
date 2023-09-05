variable "env" {}
variable "feature_name" {}
variable "vpc_id" {}
variable "public_subnet" {}
variable "domain_arn" {}
variable "hosted_zone" {}
variable "tags" {}

locals {
  lb_name             = lower("${var.env}-${var.feature_name}-lb")
  security_group_name = lower("${var.env}-${var.feature_name}-lb-sg")
}

resource "aws_lb" "common" {
  name               = local.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.public_subnet

  enable_deletion_protection = true

  tags = var.tags
}

resource "aws_lb_listener" "front_end_http" {
  load_balancer_arn = aws_lb.common.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "front_end_https" {
  load_balancer_arn = aws_lb.common.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.domain_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found target"
      status_code  = "404"
    }
  }
}

resource "aws_security_group" "lb_sg" {
  name_prefix = local.security_group_name
  description = "Allow http/https to the search load balancer"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow HTTPS to LB"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow HTTP to LB"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    var.tags,
    { "Name" = local.security_group_name },
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "common" {
  zone_id = var.hosted_zone
  name    = lower("${var.env}-${var.feature_name}-lb")
  type    = "A"
  alias {
    name                   = aws_lb.common.dns_name
    zone_id                = aws_lb.common.zone_id
    evaluate_target_health = true
  }
}

output "lb_arn" {
  value = aws_lb.common.arn
}

output "lb_endpoint" {
  value = aws_route53_record.common.fqdn
}

output "lb_front_end_http_arn" {
  value = aws_lb_listener.front_end_http.arn
}

output "lb_front_end_https_arn" {
  value = aws_lb_listener.front_end_https.arn
}

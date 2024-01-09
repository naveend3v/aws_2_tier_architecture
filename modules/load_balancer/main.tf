# Create ALB security group
locals {
  inbound_ports  = [80, 443]
  outbound_ports = [0]
}

resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "application load balancer security group"
  vpc_id      = var.alb_vpc_id

  dynamic "ingress" {
    for_each = toset(local.inbound_ports)
    content {
      description = "inbound from internet"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = toset(local.outbound_ports)
    content {
      description = "outbound to internet"
      from_port   = egress.value
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Name = "alb_sg"
  }
}

# Create ALB Target Group
resource "aws_lb_target_group" "alb_target_group" {
  name     = var.alb_target_group_name
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.alb_vpc_id
  health_check {
    enabled = true
    protocol = "HTTP"
    path = "/signin"
    port = "traffic-port"
    matcher = 200
    healthy_threshold = 5
    unhealthy_threshold = 3
    timeout = 5
    interval = 30
  }
}

# Create ALB
resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  ip_address_type = "ipv4"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [var.alb_subnet_1,var.alb_subnet_2]

  tags = {
    Environment = "production"
  }
}

# Create ALB listener
resource "aws_lb_listener" "alb_listener_https" {
  load_balancer_arn = aws_lb.alb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Default response from ALB"
      status_code  = "200"
    }
  }
  }

# Create ALB listener rules
resource "aws_lb_listener_rule" "alb_listener_rule_redirect_1" {
  listener_arn = aws_lb_listener.alb_listener_https.arn

  action {
    type             = "redirect"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    redirect {
      path = "/signup"
      status_code = "HTTP_302"
    }
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }

  priority = 1
}

resource "aws_lb_listener_rule" "alb_listener_rule_signup" {
  listener_arn = aws_lb_listener.alb_listener_https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/signup"]
    }
  }

  priority = 2
}

resource "aws_lb_listener_rule" "alb_listener_rule_signin" {
  listener_arn = aws_lb_listener.alb_listener_https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/signin"]
    }
  }

  priority = 3
}

resource "aws_lb_listener_rule" "alb_listener_rule_dashboard" {
  listener_arn = aws_lb_listener.alb_listener_https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/dashboard"]
    }
  }

  priority = 4
}


resource "aws_lb_listener_rule" "alb_listener_rule_redirect_2" {
  listener_arn = aws_lb_listener.alb_listener_https.arn

  action {
    type             = "redirect"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    redirect {
      path = "/signin"
      status_code = "HTTP_302"
    }
  }

  condition {
    path_pattern {
      values = ["/signout"]
    }
  }

  priority = 5
}
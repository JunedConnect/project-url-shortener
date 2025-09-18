 resource "aws_lb" "LCT-ALB" {
  name               = var.alb_name
  internal           = var.alb_internal
  load_balancer_type = var.alb_load_balancer_type
  security_groups    = [var.security_group_id]
  subnets            = var.public-subnet-ids
}


resource "aws_alb_listener" "Listener" {
  load_balancer_arn = aws_lb.LCT-ALB.id
  port              = var.listener_port_http
  protocol          = var.listener_protocol_http

    default_action {
    type = "redirect"
    redirect {
      protocol = var.listener_protocol_https
      port     = var.listener_port_https
      status_code = "HTTP_301"
    }
  }
}


resource "aws_alb_listener" "ListenerSSL" {
  load_balancer_arn = aws_lb.LCT-ALB.id
  port              = var.listener_port_https
  protocol          = var.listener_protocol_https
  certificate_arn = var.certificate_arn
   
  default_action {
    target_group_arn = aws_lb_target_group.this.id
    type             = "forward"
  }
}

resource "aws_lb_target_group" "this" {
  name        = var.target_group_name
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  target_type = var.target_group_target_type
  vpc_id      = var.vpc_id
  health_check {
    enabled = "true"
    path = "/healthz"
  }
}
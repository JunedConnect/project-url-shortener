 resource "aws_lb" "this" {
  name               = var.name
  internal           = var.alb_internal
  load_balancer_type = var.alb_load_balancer_type
  security_groups    = [var.security_group_id]
  subnets            = var.public-subnet-ids
}


resource "aws_alb_listener" "this" {
  load_balancer_arn = aws_lb.this.id
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


resource "aws_alb_listener" "this-ssl" {
  load_balancer_arn = aws_lb.this.id
  port              = var.listener_port_https
  protocol          = var.listener_protocol_https
  certificate_arn = var.certificate_arn
   
  default_action {
    target_group_arn = aws_lb_target_group.blue.id
    type             = "forward"
  }
}

resource "aws_lb_target_group" "blue" {
  name        = var.target_group_name_blue
  port        = var.target_group_port_blue
  protocol    = var.target_group_protocol
  target_type = var.target_group_target_type
  vpc_id      = var.vpc_id
  health_check {
    enabled = "true"
    path = var.target_group_health_check_path_blue
  }
}

resource "aws_lb_target_group" "green" {
  name        = var.target_group_name_green
  port        = var.target_group_port_green
  protocol    = var.target_group_protocol
  target_type = var.target_group_target_type
  vpc_id      = var.vpc_id
  health_check {
    enabled = "true"
    path = var.target_group_health_check_path_green
  }
}
resource "aws_lb" "alb" {
  name               = "${local.environment}-${local.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnets.vpc_subnets.ids
  ip_address_type    = "ipv4"
  tags               = local.tags
}

resource "aws_lb_target_group" "alb_tg" {
  name             = "${local.environment}-${local.project_name}-alb-tg"
  port             = 80
  protocol         = "HTTP"
  target_type      = "ip"
  protocol_version = "HTTP1"
  ip_address_type  = "ipv4"
  vpc_id           = var.vpc_id
  tags             = local.tags
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  tags              = local.tags

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}
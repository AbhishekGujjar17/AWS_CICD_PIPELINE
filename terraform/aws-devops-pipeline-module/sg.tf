resource "aws_security_group" "alb_sg" {
  name        = "${local.environment}-${local.project_name}-alb-sg"
  description = "Sg for the ALB"
  vpc_id      = var.vpc_id
  tags        = merge(local.tags, { Name = "${local.environment}-${local.project_name}-alb-sg" })
}

resource "aws_security_group_rule" "alb_outbound" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_service_sg.id
  security_group_id        = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "alb_inbound" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group" "ecs_service_sg" {
  name        = "${local.environment}-${local.project_name}-service-sg"
  description = "Sg for the ECS Service"
  vpc_id      = var.vpc_id
  tags        = merge(local.tags, { Name = "${local.environment}-${local.project_name}-alb-sg" })
}

resource "aws_security_group_rule" "service_outbound_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_service_sg.id
}

resource "aws_security_group_rule" "service_inbound" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.ecs_service_sg.id
}

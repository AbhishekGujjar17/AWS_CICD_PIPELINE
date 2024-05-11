resource "aws_ecs_cluster" "cluster" {
  name = "${local.environment}-${local.project_name}-cluster"
  tags = local.tags
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${local.environment}-${local.project_name}-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = "arn:aws:iam::${local.account_id}:role/ecsTaskExecutionRole"
  task_role_arn            = "arn:aws:iam::${local.account_id}:role/ecsTaskExecutionRole"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name      = "${local.environment}-${local.project_name}-container"
      image     = "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/${local.environment}-${local.project_name}-ecr:latest"
      essential = true
      portMappings = [
        {
          name          = "${local.project_name}-80-tcp"
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      log_configuration = {
        log_driver = "awslogs"
        options = {
          "awslogs-create-group"  = "true"
          "awslogs-group"         = "/ecs/${local.environment}-${local.project_name}-task-definition"
          "awslogs-region"        = local.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "service" {
  name             = "${local.environment}-${local.project_name}-service"
  cluster          = aws_ecs_cluster.cluster.id
  task_definition  = aws_ecs_task_definition.task_definition.arn
  desired_count    = 2
  launch_type      = "FARGATE"
  platform_version = "LATEST"
  network_configuration {
    subnets          = data.aws_subnets.vpc_subnets.ids
    security_groups  = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    container_name   = "${local.environment}-${local.project_name}-container"
    container_port   = 80
  }
}
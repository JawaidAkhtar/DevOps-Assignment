resource "aws_ecs_cluster" "this" {
  name = "devops-cluster"
}

resource "aws_ecs_task_definition" "backend" {
  family                   = "backend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = "256"
  memory                  = "512"
  execution_role_arn      = var.execution_role_arn
  task_role_arn           = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = var.image_uri
      portMappings = [
        {
          containerPort = 8000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "backend" {
  name            = "backend-service"
  cluster         = aws_ecs_cluster.this.id
  launch_type     = "FARGATE"
  desired_count   = 1
  task_definition = aws_ecs_task_definition.backend.arn

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.ecs_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "backend"
    container_port   = 8000
  }

  depends_on = [aws_ecs_task_definition.backend]
}

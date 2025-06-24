provider "aws" {
  region = var.aws_region
}

module "network" {
  source     = "./modules/network"
  aws_region = var.aws_region
}

module "security" {
  source  = "./modules/security"
  vpc_id  = module.network.vpc_id
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.network.vpc_id
  public_subnets = module.network.public_subnets
  alb_sg_id      = module.security.alb_sg_id
}

module "ecs_backend" {
  source            = "./modules/ecs_backend"
  image_uri         = var.backend_image_uri
  subnets           = module.network.public_subnets
  ecs_sg_id         = module.security.ecs_sg_id
  target_group_arn  = module.alb.backend_tg_arn
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_execution.arn
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
        Sid = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

module "ecs_frontend" {
  source            = "./modules/ecs_frontend"
  image_uri         = var.frontend_image_uri
  cluster_id        = module.ecs_backend.cluster_id
  subnets           = module.network.public_subnets
  ecs_sg_id         = module.security.ecs_sg_id
  target_group_arn  = module.alb.frontend_tg_arn
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_execution.arn
}



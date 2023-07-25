variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}

provider "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region  = "us-west-1"
  profile = "default"
}

resource "aws_ecs_cluster" "my_cluster" {
  name = "cluster"
}

resource "aws_ecs_task_definition" "my_task" {
  family                   = "myrailsapp"
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "3072"
  execution_role_arn       = "arn:aws:iam::345762154890:role/ecsTaskExecutionRole"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([
    {
      name           = "rails",
      image          = "345762154890.dkr.ecr.us-west-1.amazonaws.com/myrailsapp",
      cpu            = 0,
      essential      = true,
      logConfiguration = {
        logDriver = "awslogs",
        options   = {
          "awslogs-create-group"   = "true",
          "awslogs-group"          = "/ecs/myrailsapp",
          "awslogs-region"         = "us-west-1",
          "awslogs-stream-prefix"  = "ecs"
        }
      },
      portMappings = [{
        containerPort = 3000,
        hostPort      = 3000,
        protocol      = "tcp"
      }],
      environment = [
        {
          name  = "RAILS_LOG_TO_STDOUT",
          value = "true"
        },
        {
          name  = "RAILS_ENV",
          value = "production"
        }
      ]
    },
    {
      name         = "nginx",
      image        = "345762154890.dkr.ecr.us-west-1.amazonaws.com/my-nginx-image",
      cpu          = 0,
      essential    = true,
      portMappings = [{
        containerPort = 80,
        hostPort      = 80,
        protocol      = "tcp"
      }]
    }
  ])
}

resource "aws_ecs_service" "my_service" {
  name            = "myapp-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = ["subnet-04a9c3f01d391d924", "subnet-069d606984969a8c9"]
    security_groups = ["sg-0c44a7442335c9318"]
    assign_public_ip = true
  }
}
provider "aws" {
  region = var.aws_region
}

# Create ECS Cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = "my-ecs-cluster"
}

# Create IAM role for ECS task execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com",
      },
    }],
  })
}

# Attach AmazonECSTaskExecutionRolePolicy to the IAM role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}

# Create ECS Task Definition
resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-task-family"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name  = "my-container"
    image = "react-repo/react-app:latest"
    portMappings = [{
      containerPort = 80,
      hostPort      = 80,
    }]
  }])
}

# Create ECS Service
resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  launch_type     = "EC2"

  network_configuration {
    subnets = ["subnet-0c1901ddcda441b8e"]  # Replace with your subnet IDs
    security_groups = ["sg-0f8e99bc729048050"]  # Replace with your security group IDs
  }

  depends_on = [aws_ecs_cluster.my_cluster]
}

resource "aws_ecs_cluster" "this" {
  name = var.name

}


resource "aws_ecs_service" "this" {
  name                               = var.name
  launch_type                        = var.ecs_launch_type
  platform_version                   = var.ecs_platform_version
  cluster                            = aws_ecs_cluster.this.id
  task_definition                    = aws_ecs_task_definition.this.id
  scheduling_strategy                = var.ecs_scheduling_strategy
  desired_count                      = var.ecs_desired_count

  network_configuration {
    assign_public_ip = false
    security_groups  = [var.security_group_id]
    subnets          = var.private-subnet-ids
  }


  load_balancer {
    target_group_arn = var.target_group_id
    container_name   = var.ecs_container_name
    container_port   = var.ecs_container_port
  }
}


resource "aws_ecs_task_definition" "this" {
  family                   = var.ecs_task_family
  requires_compatibilities = var.ecs_task_requires_compatibilities
  task_role_arn            = aws_iam_role.ecs.arn
  execution_role_arn       = aws_iam_role.ecs.arn
  network_mode             = var.ecs_network_mode
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_memory
  container_definitions = jsonencode([
    {
      name      = "container"
      image     = var.ecs_container_image
      cpu       = var.ecs_container_cpu
      memory    = var.ecs_container_memory
      essential = true
      portMappings = [
        {
          containerPort = var.ecs_container_port
          hostPort      = var.ecs_container_host_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.ecs_task_family}" #fix the variables everywhere
          awslogs-region        = "eu-west-2" #make this into a variable
          awslogs-stream-prefix = "ecs"
          awslogs-create-group  = "true"
        }
      }
    }
  ])
}




resource "aws_iam_role" "ecs" {
  name = "ecs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs-policy-attachment-main" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs.name
}

resource "aws_iam_role_policy_attachment" "ecs-policy-attachment-dynamodb" {
  policy_arn = aws_iam_policy.dynamodb-table-access.arn
  role       = aws_iam_role.ecs.name
}


resource "aws_dynamodb_table" "this" {
    name           = "changeme"
    hash_key       = "id"
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery {
        enabled = "true"
    }

    attribute {
        name = "id"
        type = "S"
    }

}

resource "aws_iam_policy" "dynamodb-table-access" {
  name        = "DynamoDB-table-urlshortener-access"
  description = "Allow ECS task to GetItem and PutItem on the URL shortener table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem"
        ]
        Resource = aws_dynamodb_table.this.arn
      }
    ]
  })
}
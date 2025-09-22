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

  deployment_controller {
   type = "CODE_DEPLOY"
  }

  network_configuration {
    assign_public_ip = false
    security_groups  = [var.security_group_id]
    subnets          = var.private-subnet-ids
  }


  load_balancer {
    target_group_arn = var.target_group_id_blue
    container_name   = var.ecs_container_name
    container_port   = var.ecs_container_container_port
  }

  lifecycle {
    ignore_changes = [
      task_definition, # this is needed in order for the task revision to not constantly update on every Terraform Apply
      load_balancer, # this is needed so that CodeDeploy does not fail the Terraform Apply. The situation where this may happen will be after you have ran Deployment Strategy and then want to run Terraform Apply again on your code again
      desired_count # this is optional. ECS will no longer enforce the desired count if Terraform was to be applied a second (or third or foruth. etc) time
    ]
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
          containerPort = var.ecs_container_container_port
          hostPort      = var.ecs_container_host_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.ecs_task_family}"
          awslogs-region        = "eu-west-2"
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
    name           = var.dynamodb_table_name
    hash_key       = var.dynamodb_hash_key_name
    billing_mode   = var.dynamodb_billing_mode
    point_in_time_recovery {
        enabled = var.dynamodb_pitr_enabled
    }

    attribute {
        name = var.dynamodb_attribute_name
        type = var.dynamodb_attribute_type
    }

}

resource "aws_iam_policy" "dynamodb-table-access" {
  name        = "DynamoDB-table-urlshortener-access"

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




resource "aws_codedeploy_app" "this" {
  compute_platform = "ECS"
  name             = var.name
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name               = aws_codedeploy_app.this.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = var.name
  service_role_arn       = aws_iam_role.codedeploy.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.this.name
    service_name = aws_ecs_service.this.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.listener_ssl_arn]
      }

      target_group {
        name = var.target_group_name_blue
      }

      target_group {
        name = var.target_group_name_green
      }
    }
  }
}

resource "aws_iam_role" "codedeploy" {
  name = "codedeploy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy-policy-attachment-deployer" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployDeployerAccess"
  role       = aws_iam_role.codedeploy.name
}

resource "aws_iam_role_policy_attachment" "codedeploy-policy-attachment-ecs" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  role       = aws_iam_role.codedeploy.name
}
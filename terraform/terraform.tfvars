# General
name   = "test"
aws-tags = {
  Environment = "dev"
  Owner       = "juned"
  Terraform   = "true"
}

# ALB
alb_name                        = "this"
alb_internal                    = false
alb_load_balancer_type          = "application"
listener_port_http              = "80"
listener_protocol_http          = "HTTP"
listener_port_https             = "443"
listener_protocol_https         = "HTTPS"

# ECS
ecs_cluster_name                = "this"
ecs_service_name                = "MyService"
ecs_launch_type                 = "FARGATE"
ecs_platform_version            = "LATEST"
ecs_scheduling_strategy         = "REPLICA"
ecs_desired_count               = 1
ecs_container_name              = "container"
ecs_container_port              = 3000
ecs_task_family                 = "Threat-Composer-Tool-TD"
ecs_task_requires_compatibilities = ["FARGATE"]
ecs_network_mode                = "awsvpc"
ecs_cpu                         = 512
ecs_memory                      = 1024
ecs_container_image             = "677276074604.dkr.ecr.eu-west-2.amazonaws.com/threat-composer-tool:latest"
ecs_container_cpu              = 256
ecs_container_memory           = 512
ecs_container_host_port        = 3000

# Route53
domain_name                     = "app.juned.co.uk"
validation_method               = "DNS"
dns_ttl                         = 60

# VPC
target_group_name               = "TG"
target_group_port               = 3000
target_group_protocol           = "HTTP"
target_group_target_type        = "ip"

vpc-cidr-block                 = "10.0.0.0/16"
publicsubnet1-cidr-block       = "10.0.1.0/24"
publicsubnet2-cidr-block       = "10.0.2.0/24"
privatesubnet1-cidr-block      = "10.0.3.0/24"
privatesubnet2-cidr-block      = "10.0.4.0/24"
enable-dns-support             = true
enable-dns-hostnames           = true
subnet-map-public-ip-on-launch = true
availability-zone-1            = "eu-west-2a"
availability-zone-2            = "eu-west-2b"
route-cidr-block               = "0.0.0.0/0"
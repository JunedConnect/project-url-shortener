# General
name   = "test"
aws-tags = {
  Environment = "dev"
  Owner       = "juned"
  Terraform   = "true"
}

# ALB
alb_internal                    = false
alb_load_balancer_type          = "application"
listener_port_http              = "80"
listener_protocol_http          = "HTTP"
listener_port_https             = "443"
listener_protocol_https         = "HTTPS"
target_group_name               = "TG"
target_group_port               = 8080
target_group_protocol           = "HTTP"
target_group_target_type        = "ip"

# ECS
ecs_service_name                = "MyService"
ecs_launch_type                 = "FARGATE"
ecs_platform_version            = "LATEST"
ecs_scheduling_strategy         = "REPLICA"
ecs_desired_count               = 1
ecs_container_name              = "container"
ecs_container_container_port    = 8080
ecs_task_family                 = "url-shortener"
ecs_task_requires_compatibilities = ["FARGATE"]
ecs_network_mode                = "awsvpc"
ecs_cpu                         = 512
ecs_memory                      = 1024
ecs_container_image             = "677276074604.dkr.ecr.eu-west-2.amazonaws.com/url-shortener"
ecs_container_cpu              = 256
ecs_container_memory           = 512
ecs_container_host_port        = 8080


dynamodb_table_name      = "url"
dynamodb_billing_mode    = "PAY_PER_REQUEST"
dynamodb_pitr_enabled    = true
dynamodb_hash_key_name   = "id"
dynamodb_attribute_name  = "id"
dynamodb_attribute_type  = "S"

# Route53
domain_name                     = "app.juned.co.uk"
validation_method               = "DNS"
dns_ttl                         = 60

# VPC
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

# WAF
waf_cloudwatch_metrics_enabled = true
waf_sampled_requests_enabled   = true
waf_metric_name                = "waf-protection"
#General

variable "name" {
  description = "Resource Name"
  type        = string
  default     = "prod"
}

variable "aws-tags" {
  description = "Tags for Resources"
  type        = map(string)
  default = {
    Environment = "dev",
    Project     = "url-shortener",
    Owner       = "juned",
    Terraform   = "true"
  }
}


# ALB

variable "alb_internal" {
  description = "Whether the ALB is internal or not"
  type        = bool
  default     = false
}

variable "alb_load_balancer_type" {
  description = "Type of the load balancer"
  type        = string
  default     = "application"
}

variable "listener_port_http" {
  description = "Port for the HTTP listener"
  type        = string
  default     = "80"
}

variable "listener_protocol_http" {
  description = "Protocol for the HTTP listener"
  type        = string
  default     = "HTTP"
}

variable "listener_port_https" {
  description = "Port for the HTTPS listener"
  type        = string
  default     = "443"
}

variable "listener_protocol_https" {
  description = "Protocol for the HTTPS listener"
  type        = string
  default     = "HTTPS"
}

variable "target_group_name_blue" {
  description = "Name of the Blue target group"
  type        = string
  default     = "prod-blue"
}
variable "target_group_name_green" {
  description = "Name of the Green target group"
  type        = string
  default     = "prod-green"
}
variable "target_group_port_blue" {
  description = "Port for the blue target group"
  type        = number
  default     = 8080
}

variable "target_group_port_green" {
  description = "Port for the green target group"
  type        = number
  default     = 8080
}

variable "target_group_health_check_path_blue" {
  description = "Health check path for the blue target group"
  type        = string
  default     = "/healthz"
}

variable "target_group_health_check_path_green" {
  description = "Health check path for the green target group"
  type        = string
  default     = "/healthz"
}

variable "target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

variable "target_group_target_type" {
  description = "Target type for the target group"
  type        = string
  default     = "ip"
}


# ECS

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "prod-service"
}

variable "ecs_launch_type" {
  description = "Launch type for the ECS service"
  type        = string
  default     = "FARGATE"
}

variable "ecs_platform_version" {
  description = "Platform version for the ECS service"
  type        = string
  default     = "LATEST"
}

variable "ecs_scheduling_strategy" {
  description = "Scheduling strategy for the ECS service"
  type        = string
  default     = "REPLICA"
}

variable "ecs_desired_count" {
  description = "Desired count for ECS service tasks"
  type        = number
  default     = 2
}

variable "ecs_container_name" {
  description = "Name of the ECS container"
  type        = string
  default     = "container"
}

variable "ecs_container_container_port" {
  description = "Container port for ECS service"
  type        = number
  default     = 8080
}

variable "ecs_task_family" {
  description = "Task family for ECS task definition"
  type        = string
  default     = "url-shortener"
}

variable "ecs_task_requires_compatibilities" {
  description = "The compatibility requirements for the ECS task definition (e.g., FARGATE or EC2)"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "ecs_network_mode" {
  description = "Network mode for ECS task"
  type        = string
  default     = "awsvpc"
}

variable "ecs_cpu" {
  description = "CPU units for ECS task"
  type        = number
  default     = 512
}

variable "ecs_memory" {
  description = "Memory (in MiB) for ECS task"
  type        = number
  default     = 1024
}

variable "ecs_container_image" {
  description = "Docker image for ECS container"
  type        = string
  default     = "677276074604.dkr.ecr.eu-west-2.amazonaws.com/url-shortener:initialblue"
}

variable "ecs_container_cpu" {
  description = "CPU units for the ECS container"
  type        = number
  default     = 256
}

variable "ecs_container_memory" {
  description = "Memory (in MiB) for ECS container"
  type        = number
  default     = 512
}

variable "ecs_container_host_port" {
  description = "Host port for the ECS container"
  type        = number
  default     = 8080
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name"
  type        = string
  default     = "url-prod"
}

variable "dynamodb_hash_key_name" {
  description = "DynamoDB table hash key name"
  type        = string
  default     = "id"
}

variable "dynamodb_attribute_name" {
  description = "DynamoDB attribute name (for attribute block)"
  type        = string
  default     = "id"
}

variable "dynamodb_attribute_type" {
  description = "DynamoDB attribute type (S | N | B) for attribute block"
  type        = string
  default     = "S"
}

variable "dynamodb_billing_mode" {
  description = "DynamoDB billing mode (PAY_PER_REQUEST | PROVISIONED)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "dynamodb_pitr_enabled" {
  description = "Enable point-in-time recovery (PITR)"
  type        = bool
  default     = true
}

variable "dynamodb_ttl_attribute_name" {
  description = "DynamoDB TTL attribute name"
  type        = string
  default     = "ttl"
}

variable "dynamodb_ttl_enabled" {
  description = "Enable DynamoDB TTL"
  type        = bool
  default     = true
}


#route53

variable "domain_name" {
  description = "The domain name for the hosted zone"
  type        = string
  default     = "prod.juned.co.uk"
}

variable "validation_method" {
  description = "The validation method for the ACM certificate"
  type        = string
  default     = "DNS"
}

variable "dns_ttl" {
  description = "Time to live (TTL) for DNS records"
  type        = number
  default     = 60
}


#vpc

variable "vpc-cidr-block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.2.0.0/16"
}

variable "publicsubnet1-cidr-block" {
  description = "CIDR block for public subnet 1"
  type        = string
  default     = "10.2.1.0/24"
}

variable "publicsubnet2-cidr-block" {
  description = "CIDR block for public subnet 2"
  type        = string
  default     = "10.2.2.0/24"
}

variable "privatesubnet1-cidr-block" {
  description = "CIDR block for private subnet 1"
  type        = string
  default     = "10.2.3.0/24"
}

variable "privatesubnet2-cidr-block" {
  description = "CIDR block for private subnet 2"
  type        = string
  default     = "10.2.4.0/24"
}

variable "enable-dns-support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable-dns-hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "subnet-map-public-ip-on-launch" {
  description = "Whether to map public IP on launch for subnets"
  type        = bool
  default     = true
}

variable "availability-zone-1" {
  description = "Availability zone 1"
  type        = string
  default     = "eu-west-2a"
}

variable "availability-zone-2" {
  description = "Availability zone 2"
  type        = string
  default     = "eu-west-2b"
}

variable "route-cidr-block" {
  description = "CIDR block for the route"
  type        = string
  default     = "0.0.0.0/0"
}


# WAF

variable "waf_cloudwatch_metrics_enabled" {
  description = "Whether CloudWatch metrics are enabled for WAF visibility config"
  type        = bool
  default     = true
}

variable "waf_sampled_requests_enabled" {
  description = "Whether sampled requests are enabled for WAF visibility config"
  type        = bool
  default     = true
}

variable "waf_metric_name" {
  description = "Metric name for WAF visibility config"
  type        = string
  default     = "waf-protection"
}
#General

variable "name" {
  description = "Resource Name"
  type        = string
  default     = "test"
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


# ECS

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "MyService"
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
  default     = 1
}

variable "ecs_container_name" {
  description = "Name of the ECS container"
  type        = string
  default     = "container"
}

variable "ecs_container_port" {
  description = "Container port for ECS service"
  type        = number
  default     = 3000
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
  default     = "677276074604.dkr.ecr.eu-west-2.amazonaws.com/url-shortener"
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
  default     = 3000
}


#route53

variable "domain_name" {
  description = "The domain name for the hosted zone"
  type        = string
  default     = "app.juned.co.uk"
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

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
  default     = "TG"
}

variable "target_group_port" {
  description = "Port for the target group"
  type        = number
  default     = 8080
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

variable "vpc-cidr-block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "publicsubnet1-cidr-block" {
  description = "CIDR block for public subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "publicsubnet2-cidr-block" {
  description = "CIDR block for public subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "privatesubnet1-cidr-block" {
  description = "CIDR block for private subnet 1"
  type        = string
  default     = "10.0.3.0/24"
}

variable "privatesubnet2-cidr-block" {
  description = "CIDR block for private subnet 2"
  type        = string
  default     = "10.0.4.0/24"
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
variable "name" {
  description = "Resource Name"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID for ECS"
  type        = string
}

variable "target_group_id_blue" {
  description = "Blue Target Group ID for ECS"
  type        = string
}

variable "target_group_name_blue" {
  description = "Name of the Blue target group"
  type        = string
}
variable "target_group_name_green" {
  description = "Name of the Green target group"
  type        = string
}

variable "listener_arn" {
  description = "Listener Arn"
  type        = string
}

variable "listener_ssl_arn" {
  description = "Listener SSL Arn"
  type        = string
}

variable "private-subnet-ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "ecs_launch_type" {
  description = "Launch type for the ECS service"
  type        = string
}

variable "ecs_platform_version" {
  description = "Platform version for the ECS service"
  type        = string
}

variable "ecs_scheduling_strategy" {
  description = "Scheduling strategy for the ECS service"
  type        = string
}

variable "ecs_desired_count" {
  description = "Desired count for ECS service tasks"
  type        = number
}

variable "ecs_container_name" {
  description = "Name of the ECS container"
  type        = string
}

variable "ecs_container_container_port" {
  description = "Container port for ECS service"
  type        = number
}

variable "ecs_task_family" {
  description = "Task family for ECS task definition"
  type        = string
}

variable "ecs_task_requires_compatibilities" {
  description = "The compatibility requirements for the ECS task definition (e.g., FARGATE or EC2)"
  type        = list(string)
}

variable "ecs_network_mode" {
  description = "Network mode for ECS task"
  type        = string
}

variable "ecs_cpu" {
  description = "CPU units for ECS task"
  type        = number
}

variable "ecs_memory" {
  description = "Memory (in MiB) for ECS task"
  type        = number
}

variable "ecs_container_image" {
  description = "Docker image for ECS container"
  type        = string
}

variable "ecs_container_cpu" {
  description = "CPU units for the ECS container"
  type        = number
}

variable "ecs_container_memory" {
  description = "Memory (in MiB) for ECS container"
  type        = number
}

variable "ecs_container_host_port" {
  description = "Host port for the ECS container"
  type        = number
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name"
  type        = string
}

variable "dynamodb_hash_key_name" {
  description = "DynamoDB table hash key name"
  type        = string
}

variable "dynamodb_attribute_name" {
  description = "DynamoDB attribute name (for attribute block)"
  type        = string
}

variable "dynamodb_attribute_type" {
  description = "DynamoDB attribute type (S | N | B) for attribute block"
  type        = string
}

variable "dynamodb_billing_mode" {
  description = "DynamoDB billing mode (PAY_PER_REQUEST | PROVISIONED)"
  type        = string
}

variable "dynamodb_pitr_enabled" {
  description = "Enable point-in-time recovery (PITR)"
  type        = bool
}

variable "dynamodb_ttl_attribute_name" {
  description = "DynamoDB TTL attribute name"
  type        = string
}

variable "dynamodb_ttl_enabled" {
  description = "Enable DynamoDB TTL"
  type        = bool
}
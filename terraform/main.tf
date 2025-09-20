module "alb" {
    source = "./modules/alb"
    security_group_id = module.vpc.security_group_id
    certificate_arn = module.route53.certificate_arn
    public-subnet-ids = module.vpc.public-subnet-ids

    name                         = var.name
    alb_internal                 = var.alb_internal
    alb_load_balancer_type       = var.alb_load_balancer_type
    listener_port_http           = var.listener_port_http
    listener_protocol_http       = var.listener_protocol_http
    listener_port_https          = var.listener_port_https
    listener_protocol_https      = var.listener_protocol_https

    vpc_id = module.vpc.vpc_id

    target_group_name              = var.target_group_name
    target_group_port              = var.target_group_port
    target_group_protocol          = var.target_group_protocol
    target_group_target_type       = var.target_group_target_type
}

module "ecs" {
    source = "./modules/ecs"
    security_group_id = module.vpc.security_group_id
    target_group_id = module.alb.target_group_id
    private-subnet-ids = module.vpc.private-subnet-ids

    name                           = var.name
    ecs_service_name               = var.ecs_service_name
    ecs_launch_type                = var.ecs_launch_type
    ecs_platform_version           = var.ecs_platform_version
    ecs_scheduling_strategy        = var.ecs_scheduling_strategy
    ecs_desired_count              = var.ecs_desired_count
    ecs_container_name             = var.ecs_container_name
    ecs_container_port             = var.ecs_container_port
    ecs_task_family                = var.ecs_task_family
    ecs_task_requires_compatibilities = var.ecs_task_requires_compatibilities
    ecs_network_mode               = var.ecs_network_mode
    ecs_cpu                        = var.ecs_cpu
    ecs_memory                     = var.ecs_memory
    ecs_container_image            = var.ecs_container_image
    ecs_container_cpu              = var.ecs_container_cpu
    ecs_container_memory           = var.ecs_container_memory
    ecs_container_host_port        = var.ecs_container_host_port

    dynamodb_table_name            = var.dynamodb_table_name
    dynamodb_hash_key_name         = var.dynamodb_hash_key_name
    dynamodb_attribute_name        = var.dynamodb_attribute_name
    dynamodb_attribute_type        = var.dynamodb_attribute_type
    dynamodb_billing_mode          = var.dynamodb_billing_mode
    dynamodb_pitr_enabled          = var.dynamodb_pitr_enabled
}

module "route53" {
    source = "./modules/route53"
    alb_dns_name = module.alb.alb_dns_name
    alb_zone_id = module.alb.alb_zone_id

    domain_name          = var.domain_name
    validation_method    = var.validation_method
    dns_ttl              = var.dns_ttl
}

module "vpc" {
  source = "./modules/vpc"

  name                           = var.name
  vpc-cidr-block                 = var.vpc-cidr-block
  publicsubnet1-cidr-block       = var.publicsubnet1-cidr-block
  publicsubnet2-cidr-block       = var.publicsubnet2-cidr-block
  privatesubnet1-cidr-block      = var.privatesubnet1-cidr-block
  privatesubnet2-cidr-block      = var.privatesubnet2-cidr-block
  enable-dns-support             = var.enable-dns-support
  enable-dns-hostnames           = var.enable-dns-hostnames
  subnet-map-public-ip-on-launch = var.subnet-map-public-ip-on-launch
  availability-zone-1            = var.availability-zone-1
  availability-zone-2            = var.availability-zone-2
  route-cidr-block               = var.route-cidr-block

}

module "waf" {
  source = "./modules/waf"

  name = var.name
  waf_association_resource_arn = module.alb.alb_arn
  cloudwatch_metrics_enabled = var.waf_cloudwatch_metrics_enabled
  sampled_requests_enabled   = var.waf_sampled_requests_enabled
  metric_name                = var.waf_metric_name
}
variable "name" {
  description = "Resource Name"
  type        = string
}

variable "cloudwatch_metrics_enabled" {
  description = "Whether CloudWatch metrics are enabled for WAF visibility config"
  type        = bool
}

variable "sampled_requests_enabled" {
  description = "Whether sampled requests are enabled for WAF visibility config"
  type        = bool
}

variable "metric_name" {
  description = "Metric name for WAF visibility config"
  type        = string
}

variable "waf_association_resource_arn" {
  description = "ARN of the resource to associate with the WAF Web ACL"
  type        = string
}

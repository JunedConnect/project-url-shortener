variable "name" {
  description = "Resource Name"
  type        = string
}

# variable "target_group_name" {
#   description = "Name of the target group"
#   type        = string
# }

# variable "target_group_port" {
#   description = "Port for the target group"
#   type        = number
# }

# variable "target_group_protocol" {
#   description = "Protocol for the target group"
#   type        = string
# }

# variable "target_group_target_type" {
#   description = "Target type for the target group"
#   type        = string
# }

variable "vpc-cidr-block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "publicsubnet1-cidr-block" {
  description = "CIDR block for public subnet 1"
  type        = string
}

variable "publicsubnet2-cidr-block" {
  description = "CIDR block for public subnet 2"
  type        = string
}

variable "privatesubnet1-cidr-block" {
  description = "CIDR block for private subnet 1"
  type        = string
}

variable "privatesubnet2-cidr-block" {
  description = "CIDR block for private subnet 2"
  type        = string
}

variable "enable-dns-support" {
  description = "Enable DNS support in the VPC"
  type        = bool
}

variable "enable-dns-hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
}

variable "subnet-map-public-ip-on-launch" {
  description = "Whether to map public IP on launch for subnets"
  type        = bool
}

variable "availability-zone-1" {
  description = "Availability zone 1"
  type        = string
}

variable "availability-zone-2" {
  description = "Availability zone 2"
  type        = string
}

variable "route-cidr-block" {
  description = "CIDR block for the route"
  type        = string
}
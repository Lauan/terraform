variable "environment" {
  description = "Environment name for tagging purposes (e.g. development, stage or production)"
  type        = string
}

variable "application" {
  description = "Main identifier of the application"
}

variable "region" {
  description = "Region where the resources will be deployed"
  type        = string
}

// OPTIONS FOR LAUNCH TEMPLATES

variable "enable_instance_detailed_monitoring" {
  description = "If TRUE, metrics are available in 1-minute periods (instead of 5-minute period if FALSE"
  type        = bool
  default     = false
}

variable "workers_instance_type" {
  description = "Instance type for instances running in the launch template (i.e. t3.small, etc)"
  type        = string
}

variable "enable_spot_instances" {
  description = "If TRUE, the node group will be created with spot instances."
  type        = bool
  default     = false
}

variable "desired_instances" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "max_instances" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "min_instances" {
  description = "Minimum number of worker nodes"
  type        = number
}
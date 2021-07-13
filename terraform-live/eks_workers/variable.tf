variable "environment" {
  description = "Environment name for tagging purposes (e.g. development, stage or production)"
  type        = string
}

variable "billing" {
  description = "Structure billing identifier (network, database, application, etc)"
}

variable "product" {
  description = "Main identifier of the product"
}

variable "region" {
  description = "Region where the resources will be deployed"
  type        = string
}

variable "account_id" {
  description = "Account ID to use on roles and policies"
  type        = string
}

// variable "minimum_ondemand_instances"{
//   description = "Minimum number of on-demand instances to be provisioned on the cluster"
//   type        = number
//   default     = 2
// }

// variable "ondemand_instances_over_spot" {
//   description = "Share (percentage) of on-demand instances to be provisioned after 'minimum_ondemand_instances' capacity is reached. The rest of the instances will be Spot"
//   type        = number
//   default     = 100
// }

// variable "spot_max_price" {
//   description = "Max price to pay for Spot Instances"
//   type        = string
// }

variable "workers_instance_type" {
  description = "Instance type for instances running in the launch template (i.e. t3.small, etc)"
  type        = string
}

variable "k8s_version" {
  description = "Kubernetes cluster major version"
  type        = string
  default     = "1.19"
}

variable "public_key"{
  description = "Public key to create the KeyPair for the worker nodes"
  type        = string
}
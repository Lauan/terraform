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

variable "eks_oidc_root_ca_thumbprint" {
  type        = string
  description = "Thumbprint of Root CA for EKS OIDC, Valid until 2037"
  default     = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
}

variable "cluster_enabled_log_types" {
  description = "List of the control plane main components that must generate logs."
  type        = list(string)
  default     = []
}

variable "k8s_version" {
  description = "Kubernetes cluster major version"
  type        = string
  default     = "1.19"
}

variable "cluster_endpoint_private_access" {
  description = "Wether to enable or not a private API endpoint for the kubernetes cluster"
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access" {
  description = "Wether to enable or not a public API endpoint for the kubernetes cluster"
  type        = bool
  default     = true
}

variable "cluster_public_access_cidrs" {
  description = "List of CIDRs that the control plane will use to allow access from."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_service_ipv4_cidr" {
  description = "CIDR to be used by the kubernetes cluster for services."
  type        = string
}

variable "kubeconfig_aws_authenticator_command" {
  description = "Command to use to fetch AWS EKS credentials."
  type        = string
  default     = "aws-iam-authenticator"
}

variable "kubeconfig_aws_authenticator_command_args" {
  description = "Default arguments passed to the authenticator command. Defaults to [token -i $cluster_name]."
  type        = list(string)
  default     = []
}

variable "output_kubeconfig" {
  description = "If set to true, the kubeconfig file will be printed as output"
  type        = bool
  default     = true
}
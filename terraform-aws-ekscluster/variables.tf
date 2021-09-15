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

variable "public_key"{
  description = "Public key to create the KeyPair for the worker nodes"
  type        = string
}

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
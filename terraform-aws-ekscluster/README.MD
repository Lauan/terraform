# terraform-aws-ekscluster

## Requirements / Providers

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 3.47 |

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment name for tagging purposes (e.g. development, stage or production) | `string` | N/A | Yes |
| application | Main identifier of the application | `string` | N/A | Yes |
| region | Region where the resources will be deployed | `string` | N/A | Yes |
| public_key | Public key to create the KeyPair for the worker nodes | `string` | N/A | Yes |
| eks_oidc_root_ca_thumbprint | Thumbprint of Root CA for EKS OIDC, Defaults to a valid one until 2037 | `string` | 9e99a48a9960b14926bb7f3b02e22da2b0ab7280 | No |
| cluster_enabled_log_types | List of the control plane main components that must generate logs. | `list(string)` | [] | No |
| k8s_version | Kubernetes cluster major version | string | 1.19 | No |
| cluster_endpoint_private_access | Wether to enable or not a private API endpoint for the kubernetes cluster | `bool` | `false` | No |
| cluster_endpoint_public_access | Wether to enable or not a public API endpoint for the kubernetes cluster | `bool` | `true` | No |
| cluster_public_access_cidrs | List of CIDRs that the control plane will use to allow access from. | `list(string)` | ["0.0.0.0/0"] | No |
| cluster_service_ipv4_cidr | CIDR to be used by the kubernetes cluster for services. | `string` | N/A | Yes |

## Deployed Resources (# of instances)

- aws_eks_cluster (1)
- aws_cloudwatch_log_group (1)
- aws_iam_openid_connect_provider (1)
- aws_iam_role (2)
- aws_iam_role_policy_attachment (2)
- aws_key_pair (1)
- aws_kms_key (1)
- aws_security_group (2)
- aws_security_group_rule (9)

## Output Variables

| Name | Description |
|------|-------------|
cluster_endpoint | API URL Endpoint to access the cluster |
cluster_id | ID (name) of the EKS Cluster |
cluster_oidc_issuer_url | EKS Clusters's OIDC Issuer URL |
cluster_oidc_arn | EKS Clusters's OIDC ARN |
cluster_oidc_provider_id | EKS Clusters's OIDC Provider ID |

## Usage Example

### main.tf

```js
provider "aws" {
  region = var.region
}

module "eks_cluster" {
  source = {REGISTRY_PATH_OR_URL}
  environment = var.environment
  application = var.application
  region = var.region
  public_key = var.public_key
  cluster_enabled_log_types = var.cluster_enabled_log_types
  k8s_version = var.k8s_version
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access = var.cluster_endpoint_public_access
  cluster_public_access_cidrs = var.cluster_public_access_cidrs
  cluster_service_ipv4_cidr = var.cluster_service_ipv4_cidr
}
```

### variables.tf

```js

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
```

### terraform.auto.tfvars

```js
environment = "value"
application = "value"
region = "value"
public_key = "locally generated key"
cluster_enabled_log_types = ["value", "value"]
k8s_version = "value"
cluster_endpoint_private_access = false
cluster_endpoint_public_access = true
cluster_public_access_cidrs = ["value"]
cluster_service_ipv4_cidr = "value"
```

### outputs.tf

```js
output "cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}

output "cluster_id" {
  value = module.eks_cluster.cluster_id
}

output "cluster_oidc_issuer_url" {
  value = module.eks_cluster.cluster_oidc_issuer_url
}

output "cluster_oidc_arn" {
  value = module.eks_cluster.cluster_oidc_arn
}

output "cluster_oidc_provider_id" {
  value = module.eks_cluster.cluster_oidc_provider_id
}
```
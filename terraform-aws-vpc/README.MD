# terraform-aws-network

## Requirements / Providers

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 3.47 |

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_id | VPC's ID | `string` | n/a | yes |
| vpc_cidr | Main VPC CIDR Block | `string` | N/A | yes |
| public_subnets | List of public subnets CIDRs | `list(string)` | [] | yes |
| private_subnets | List of private (egress only) subnets CIDRs | `list(string)` | [] | yes |
| intra_subnets | List of intra (no internet access) subnets CIDRs | `list(string)` | [] | no |
| environment | Environment name for tagging purposes (e.g. development, stage or production) | `string` | N/A | yes |
| application | Main identifier of the application | `string` | N/A | yes |
| single_natgw | Should be true if you want to provision a single shared NAT Gateway for all your private networks | `bool` | `false` | no |
| dual_az_only | Activate environments on 2 AZs only (spans across all of them if `FALSE`) | `bool` | `false` | no |
| enable_accept_flowlogs | If true, ACCEPT flow logs are created (this will create also a cloudwatch log group and some IAM objects) | `bool` | `false` | no |
| enable_reject_flowlogs | If true, REJECT flow logs are created (this will create also a cloudwatch log group and some IAM objects) | `bool` | `true` | no |
| enable_s3_endpoint | If true, a S3 endpoint is created in the VPC and associated with private route tables | `bool` | `false` | no |
| enable_dynamodb_endpoint | If true, a DynamoDB endpoint is created in the VPC and associated with private route tables | `bool` | `false` | no |
| region | Region where the resources will be deployed | string | N/A | yes |
| enable_dns_hostnames | Should be true to enable DNS hostnames in the VPC | `bool` | `false` | no |
| enable_dns_support | Should be true to enable DNS support in the VPC | `bool` | `true` | no |
| map_public_ip_on_launch | Should be `false` if you do not want to auto-assign public IP for resources launched on public subnets | `bool` | `true` | no |

## Deployed Resources (# of instances)

- aws_cloudwatch_log_group (0~2)
- aws_eip (0~n)
- aws_flow_log (0~1)
- aws_iam_role (0~1)
- aws_iam_role_policy (0~1)
- aws_internet_gateway (1)
- aws_kms_key (0~1)
- aws_nat_gateway (0~n)
- aws_route (0~n)
- aws_route_table (0~n)
- aws_route_table_association (0~n)
- aws_subnet (0~n)
- aws_vpc (1)
- aws_vpc_endpoint (0~2)
- aws_vpc_endpoint_route_table_association (0~n)

## Output Variables

| Name | Description |
|------|-------------|
| vpc_id | VPC's ID |
| vpc_cidr | VPC's CIDR Block |
| eip_addresses | List of Elastic IP Addresses |
| public_subnets | List of public subnets' CIDR Blocks |
| private_subnets | List of private subnets' CIDR Blocks |
| intra_subnets | List of intra subnets' CIDR Blocks |
| internet_gateway_id | ID of the VPC's Internet Gateway |
| nat_gateway_id | List of Nat Gateway's IDs |
| cloudwatch_log_group_flowlogs_accept | Name of the Cloudwatch Log group for accept traffic |
| cloudwatch_log_group_flowlogs_reject | Name of the Cloudwatch Log group for reject traffic |
| vpc_flowlogs_reject_enabled | Status of the VPC's FlowLogs for accept traffic |
| vpc_flowlogs_accept_enabled | Status of the VPC's FlowLogs for reject traffic |
| s3_endpoint_enabled | Status of the VPC's S3 Endpoint |
| dynamodb_endpoint_enabled | Status of the VPC's DynamoDB Endpoint |

## Usage Example

### main.tf

```js
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.47.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "network" {
  source = "../../terraform-modules/terraform-aws-network"
  vpc_cidr = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  intra_subnets = var.intra_subnets
  environment = var.environment
  application = var.application
  single_natgw = var.single_natgw
  dual_az_only = var.dual_az_only
  enable_accept_flowlogs = var.enable_accept_flowlogs
  enable_reject_flowlogs = var.enable_reject_flowlogs
  enable_s3_endpoint = var.enable_s3_endpoint
  enable_dynamodb_endpoint = var.enable_dynamodb_endpoint
  region = var.region
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  map_public_ip_on_launch = var.map_public_ip_on_launch
}
```

### variable.tf

```js
variable "vpc_cidr" {
  description = "Main VPC CIDR Block"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnets CIDRs"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "List of private (egress only) subnets CIDRs"
  type        = list(string)
  default     = []
}

variable "intra_subnets" {
  description = "List of intra (no internet access) subnets CIDRs"
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "Environment name for tagging purposes (e.g. development, stage or production)"
  type        = string
}

variable "application" {
  description = "Main identifier of the application"
}

variable "single_natgw" {
  description = "Should be true if you want to provision a single shared NAT Gateway for all your private networks"
  type        = bool
  default     = false
}

variable "dual_az_only" {
  description = "Activate environments on 2 AZs only (spans across all of them if FALSE)"
  type        = bool
  default     = false
}

variable "enable_accept_flowlogs" {
  description = "If true, ACCEPT flow logs are created (this will create also a cloudwatch log group and some IAM objects)"
  type        = bool
  default     = false
}

variable "enable_reject_flowlogs" {
  description = "If true, REJECT flow logs are created (this will create also a cloudwatch log group and some IAM objects)"
  type        = bool
  default     = true
}

variable "enable_s3_endpoint" {
  description = "If true, a S3 endpoint is created in the VPC and associated with private route tables"
  type        = bool
  default     = false
}

variable "enable_dynamodb_endpoint" {
  description = "If true, a DynamoDB endpoint is created in the VPC and associated with private route tables"
  type        = bool
  default     = false
}

variable "region" {
  description = "Region where the resources will be deployed"
  type        = string
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP for resources launched on public subnets"
  type        = bool
  default     = true
}
```

### terraform.auto.tfvars

```js
vpc_cidr = "CIDRBlock"
public_subnets = [
  "CIDRBlock",
  "CIDRBlock",
  "CIDRBlock"
  ]
private_subnets = [
  "CIDRBlock",
  "CIDRBlock",
  "CIDRBlock"
  ]
intra_subnets = []
environment = "value"
application = "value"
single_natgw = true
dual_az_only = false
enable_accept_flowlogs = false
enable_reject_flowlogs = true
enable_s3_endpoint = true
enable_dynamodb_endpoint = false
region = "value"
enable_dns_hostnames = true
enable_dns_support = true
map_public_ip_on_launch = true
```

### output.tf

```js
output "vpc_id" {
  value = module.network.vpc_id
}
output "vpc_cidr" {
  value = module.network.vpc_cidr
}
output "public_subnets"{
  value = module.network.public_subnets
}
output "private_subnets"{
  value = module.network.private_subnets
}
output "intra_subnets"{
  value = module.network.intra_subnets
}
output "cloudwatch_log_group_flowlogs_accept" {
  value = module.network.cloudwatch_log_group_flowlogs_accept
}
output "cloudwatch_log_group_flowlogs_reject" {
  value = module.network.cloudwatch_log_group_flowlogs_reject
}
output "vpc_flowlogs_reject_enabled" {
  value = module.network.vpc_flowlogs_reject_enabled
}
output "vpc_flowlogs_accept_enabled" {
  value = module.network.vpc_flowlogs_accept_enabled
}
output "s3_endpoint_enabled" {
  value = module.network.s3_endpoint_enabled
}
output "dynamodb_endpoint_enabled" {
  value = module.network.dynamodb_endpoint_enabled
}
```

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

variable "billing" {
  description = "Structure billing identifier (network, database, application, etc)"
}

variable "product" {
  description = "Main identifier of the product"
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

variable "account_id" {
  description = "Account ID to use on roles and policies"
  type        = string
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
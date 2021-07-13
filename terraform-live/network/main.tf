provider "aws" {
  region = var.region
}

module "network" {
  source = "../../network"
  vpc_cidr = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  intra_subnets = var.intra_subnets
  environment = var.environment
  billing = var.billing
  product = var.product
  single_natgw = var.single_natgw
  dual_az_only = var.dual_az_only
  account_id = var.account_id
  enable_accept_flowlogs = var.enable_accept_flowlogs
  enable_reject_flowlogs = var.enable_reject_flowlogs
  enable_s3_endpoint = var.enable_s3_endpoint
  enable_dynamodb_endpoint = var.enable_dynamodb_endpoint
  region = var.region
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  map_public_ip_on_launch = var.map_public_ip_on_launch
}
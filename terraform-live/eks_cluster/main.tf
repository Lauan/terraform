provider "aws" {
  region = var.region
}

module "eks_cluster" {
  source = "../../terraform-aws-ekscluster"
  environment = var. environment
  billing = var. billing
  product = var. product
  region = var. region
  account_id = var. account_id
  cluster_enabled_log_types = var. cluster_enabled_log_types
  k8s_version = var. k8s_version
  cluster_endpoint_private_access = var. cluster_endpoint_private_access
  cluster_endpoint_public_access = var. cluster_endpoint_public_access
  cluster_public_access_cidrs = var. cluster_public_access_cidrs
  cluster_service_ipv4_cidr = var.cluster_service_ipv4_cidr
}
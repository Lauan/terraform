provider "aws" {
  region = var.region
}

module "eks_workers" {
  source = "../../terraform-aws-eksnodegroups"
  environment = var. environment
  billing = var. billing
  product = var. product
  region = var. region
  account_id = var. account_id
  workers_instance_type = var.workers_instance_type
  k8s_version = var. k8s_version
  public_key = var. public_key
}
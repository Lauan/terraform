resource "aws_vpc" "vpc" {

  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags                 = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-vpc"
    },
    {
      Lifecycle = "Common Infrasctructure"
    }
  )
}
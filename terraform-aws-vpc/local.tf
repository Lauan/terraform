locals {
  common_tags           = {
    Terraform           = true,
    Application         = var.application
    Environment         = var.environment,
    Scope               = "Network"
    Lifecycle           = "Base_Infrastructure"
  }
  name_prefix           = "${var.application}-${var.environment}"
  public_sn_idx_map     = { for idx, value in var.public_subnets: value => idx}
  private_sn_idx_map    = { for idx, value in var.private_subnets: value => idx}
  intra_sn_idx_map      = { for idx, value in var.intra_subnets: value => idx}
  single_idx_map        = { for idx, value in [var.private_subnets[0]]: value => idx}
}
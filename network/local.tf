locals {
  common_tags           = {
    Terraform           = true,
    Product             = var.product
    Environment         = var.environment,
    Billing             = "Network"
  }
  name_prefix           = "${var.product}-${var.environment}"
}
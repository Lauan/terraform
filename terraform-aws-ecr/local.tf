locals {
  common_tags           = {
    Terraform           = true,
    Application         = var.application
    Environment         = var.environment,
    Billing             = "ContainerRegistry"
    Lifecycle           = "Application"
  }
  name_prefix           = "${var.application}-${var.environment}"
}
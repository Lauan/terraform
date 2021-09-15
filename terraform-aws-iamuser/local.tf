locals {
  name_prefix       = "${lower(var.application)}-${lower(var.environment)}"
  common_tags = {
    Application = var.application
    Environment = var.environment
    Component   = var.component
    repository  = var.repository
    Terraform   = true
    Billing     = "IAM"
    Lifecycle   = "Application"
  }
}
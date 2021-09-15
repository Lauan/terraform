locals {
  name_prefix = "${lower(var.application)}-${lower(var.environment)}"
  common_tags = {
    Application     = var.application
    Environment     = var.environment
    Terraform       = true
    Billing         = "IAM"
    Lifecycle       = "Application"
    Component       = var.component
    Repository      = var.repository
  }
}
////////////////////////////////////
// JSON DATA
////////////////////////////////////

// Generate a ServiceAccount AssumeRole json
data "aws_iam_policy_document" "assumerole" {
  statement {
    sid = var.rolename
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = var.service_principal
    }
  }
}

// CREATE ROLE FOR K8S SERVICEACCOUNTS
resource "aws_iam_role" "role" {
  name                  = lower(var.rolename)
  description           = var.roledescription
  path                  = var.rolepath == "" ? null : "/${var.rolepath}/"
  managed_policy_arns   = var.managed_policy_arns
  force_detach_policies = true
  assume_role_policy    = data.aws_iam_policy_document.assumerole.json
  tags                  = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-iam-role-${lower(var.rolename)}"
    }
  )
}
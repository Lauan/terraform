// Generate the aws_auth operator policy json
data "aws_iam_policy_document" "role_policy" {
  dynamic "statement" {
    for_each = var.policystatements
    content {
      sid = statement.key
      actions = statement.value.policyactions
      resources = statement.value.policyresources
    }
  }
}

//CREATE POLICY FOR EKS AUTH OPERATOR
resource "aws_iam_role_policy" "role_policy" {
  name               = var.policyname
  role               = aws_iam_role.role.id
  policy             = data.aws_iam_policy_document.role_policy.json
}
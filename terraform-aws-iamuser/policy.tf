// Generate the aws_auth operator policy json
data "aws_iam_policy_document" "user_policy" {
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
resource "aws_iam_user_policy" "user_policy" {
  name               = var.policyname
  user               = aws_iam_user.user.id
  policy             = data.aws_iam_policy_document.user_policy.json
}
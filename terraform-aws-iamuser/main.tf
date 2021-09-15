resource "aws_iam_user" "user" {
  name = var.username
  path = var.userpath == "" ? null : "/${var.userpath}/"
  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-iam-user-${lower(var.username)}"
    },
    var.extra_tags
  )
}

resource "aws_iam_user_policy_attachment" "policyattach" {
  for_each   = toset(var.awspolicies)
  user       = aws_iam_user.user.name
  policy_arn = each.key
}
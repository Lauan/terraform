resource "aws_ecr_repository" "repo" {
  for_each              = var.ecr_repositories
  name                  = each.key
  image_tag_mutability  = each.value.tag_overriding == true ? "MUTABLE" : "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = each.value.enable_scan
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = "${each.key}-ecr-repository"
    },
    {
      "Component" = each.value.component
    },
    {
      "Repository" = each.value.repository
    }
  )
}

resource "aws_ecr_repository_policy" "repo_policy" {
  for_each              = aws_ecr_repository.repo
  repository            = each.value.name
  policy                = data.aws_iam_policy_document.ecr_policy.json
}
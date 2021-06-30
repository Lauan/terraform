resource "aws_iam_role" "workers" {
  name                  = "EKSWorkersServiceRole"
  assume_role_policy    = data.aws_iam_policy_document.workers_role.json
  // permissions_boundary  = var.permissions_boundary
  // path                  = var.iam_path
  force_detach_policies = true
  tags              = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-iam-role-workers"
    },
    {
      Lifecycle = "Cluster applications"
    }
  )
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKSWorkerNodePolicy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKS_CNI_Policy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.workers.name
}
resource "aws_kms_key" "eks_cluster" {
  description               = "KMS for EKS cluster control plane logs"
  deletion_window_in_days   = 10
  policy                    = data.aws_iam_policy_document.kms_key_policy.json
  tags              = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-kms-key-cluster-loggroup"
    },
    {
      Lifecycle = "Cluster applications"
    }
  )
}

resource "aws_cloudwatch_log_group" "cluster" {
  name              = "/aws/eks/${local.eks_cluster_name}/cluster"
  retention_in_days = 7
  kms_key_id        = aws_kms_key.eks_cluster.arn
  tags              = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-loggroup-cluster"
    },
    {
      Lifecycle = "Cluster applications"
    }
  )
}
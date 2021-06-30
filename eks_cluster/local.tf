locals {
  arn_prefix        = "arn:${data.aws_partition.current.partition}"
  policy_arn_prefix = "${local.arn_prefix}:iam::aws:policy"
  ec2_principal     = "ec2.${data.aws_partition.current.dns_suffix}"
  sts_principal     = "sts.${data.aws_partition.current.dns_suffix}"
  oidc_url          = flatten(concat(aws_eks_cluster.cluster.identity[*].oidc.0.issuer, [""]))[0]
  oidc_provider_id  = trim(flatten(concat(aws_eks_cluster.cluster.identity[*].oidc.0.issuer, [""]))[0],"https://")
  oidc_arn          = "${local.arn_prefix}:iam::${var.account_id}:oidc-provider/${local.oidc_provider_id}"
  name_prefix       = "${lower(var.product)}-${lower(var.environment)}"
  eks_cluster_name  = "${local.name_prefix}-eks"
  common_tags = {
    Product     = var.product
    Environment = var.environment
    Terraform   = true
    Billing     = "Compute"
  }
}
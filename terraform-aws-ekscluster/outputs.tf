output "cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "cluster_id" {
  value = aws_eks_cluster.cluster.id
}

output "cluster_oidc_issuer_url" {
  value = flatten(concat(aws_eks_cluster.cluster.identity[*].oidc.0.issuer, [""]))[0]
}

output "cluster_oidc_arn" {
  value = "${local.arn_prefix}:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider_id}"
}

output "cluster_oidc_provider_id" {
  value = trim(flatten(concat(aws_eks_cluster.cluster.identity[*].oidc.0.issuer, [""]))[0],"https://")
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.cluster.certificate_authority.0.data
}
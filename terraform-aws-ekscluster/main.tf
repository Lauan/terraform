// Create the EKS Cluster
resource "aws_eks_cluster" "cluster" {
  name                      = local.eks_cluster_name
  role_arn                  = aws_iam_role.cluster.arn
  enabled_cluster_log_types = var.cluster_enabled_log_types
  version                   = var.k8s_version

  vpc_config {
    endpoint_private_access   = var.cluster_endpoint_private_access
    endpoint_public_access    = var.cluster_endpoint_public_access
    public_access_cidrs       = var.cluster_public_access_cidrs
    security_group_ids        = [aws_security_group.cluster.id]
    subnet_ids                = data.aws_subnet_ids.private.ids
  }

  // kubernetes_network_config {
  //   service_ipv4_cidr = var.cluster_service_ipv4_cidr
  // }

  tags = merge(
    local.common_tags,
    {
      Name = local.eks_cluster_name
    }
  )

  depends_on = [
    aws_security_group_rule.cluster_egress_internet,
    aws_security_group_rule.cluster_ingress_tls_workers,
    aws_security_group_rule.cluster_ingress_self,
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceControllerPolicy,
    aws_cloudwatch_log_group.cluster
  ]
}

  resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = [local.sts_principal]
  thumbprint_list = [var.eks_oidc_root_ca_thumbprint]
  url             = flatten(concat(aws_eks_cluster.cluster.identity[*].oidc.0.issuer, [""]))[0]
  tags              = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-oidc-provider"
    }
  )
}
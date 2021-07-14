resource "aws_iam_role" "cluster" {
  name                  = "EKSClusterServiceRole"
  assume_role_policy    = data.aws_iam_policy_document.cluster_role.json
  // permissions_boundary  = var.permissions_boundary
  // path                  = var.iam_path
  // force_detach_policies = true
  tags              = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-iam-role-cluster"
    },
    {
      Lifecycle = "Cluster applications"
    }
  )
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSServicePolicy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSVPCResourceControllerPolicy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster.name
}

// CREATE ROLE FOR EKS AUTOSCALING
resource "aws_iam_role" "autoscaler" {
  name               = "EKSAutoscalerServiceRole"
  description        = "Role used by Kubernetes to send autoscale requests to EKS"
  assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler_role.json
  tags              = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-iam-role-autoscaler"
    },
    {
      Lifecycle = "Cluster applications"
    }
  )
}

//CREATE POLICY FOR EKS AUTOSCALING
resource "aws_iam_role_policy" "autoscaler" {
  name               = "EKSAutoscalerPolicy"
  role               = aws_iam_role.autoscaler.id
  policy             = data.aws_iam_policy_document.cluster_autoscaler_policy.json
}

// IRSA (IAM Roles for EKS Service Accounts)
// resource "aws_iam_openid_connect_provider" "oidc_provider" {
//   client_id_list  = [local.sts_principal]
//   thumbprint_list = [var.eks_oidc_root_ca_thumbprint]
//   url             = flatten(concat(aws_eks_cluster.cluster.identity.oidc.0.issuer, [""]))[0]

//   tags = merge(
//     {
//       Name = "${var.cluster_name}-eks-irsa"
//     },
//     var.tags
//   )
// }
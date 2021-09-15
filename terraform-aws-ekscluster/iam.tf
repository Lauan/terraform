resource "aws_iam_role" "cluster" {
  name                  = "EKSClusterServiceRole"
  assume_role_policy    = data.aws_iam_policy_document.cluster_role.json
  // Path must not be set for cluster and workers (workers join into cluster will fail if any path is set)
  tags              = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-iam-role-cluster"
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

// IAM ROLE FOR WORKERS

resource "aws_iam_role" "workers" {
  name                  = "EKSWorkersServiceRole"
  assume_role_policy    = data.aws_iam_policy_document.workers_role.json
  // Path must not be set for cluster and workers (workers join into cluster will fail if any path is set)
  force_detach_policies = true
  tags              = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-iam-role-workers"
    },
    {
      "eks/${data.aws_caller_identity.current.account_id}/${local.eks_cluster_name}/groups" = "system:bootstrappers::system:nodes"
    },
    {
      "eks/${data.aws_caller_identity.current.account_id}/${local.eks_cluster_name}/type" = "node"
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
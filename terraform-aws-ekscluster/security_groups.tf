resource "aws_security_group" "cluster" {
  name                      = "${local.name_prefix}-sg-eks-cluster"
  description               = "Allow EKS Clusters pods communication"
  vpc_id                    = tolist(data.aws_vpcs.main.ids)[0]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-sg-eks-cluster"
    },
    {
      Lifecycle = "Cluster Applications"
    }
  )
}

resource "aws_security_group_rule" "cluster_egress_internet" {
  description               = "Allow cluster all egress to the Internet"
  from_port                 = 0
  to_port                   = 0
  protocol                  = "-1"
  security_group_id         = aws_security_group.cluster.id
  cidr_blocks               = ["0.0.0.0/0"]
  ipv6_cidr_blocks          = ["::/0"]
  type                      = "egress"
}

resource "aws_security_group_rule" "cluster_ingress_tls_workers" {
  description               = "Allow pods to communicate with the EKS cluster API"
  protocol                  = "tcp"
  security_group_id         = aws_security_group.cluster.id
  source_security_group_id  = aws_security_group.workers.id
  from_port                 = 443
  to_port                   = 443
  type                      = "ingress"
}

resource "aws_security_group_rule" "cluster_ingress_self" {
  description               = "Allow internal communication for the cluster"
  protocol                  = "-1"
  security_group_id         = aws_security_group.cluster.id
  source_security_group_id  = aws_security_group.cluster.id
  from_port                 = 0
  to_port                   = 0
  type                      = "ingress"
}

resource "aws_security_group" "workers" {
  name        = "${local.name_prefix}-sg-eks-workers"
  description = "Allow EKS Clusters worker nodes communication"
  vpc_id      = tolist(data.aws_vpcs.main.ids)[0]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-sg-eks-workers"
    },
    {
      Lifecycle = "Cluster Applications"
    }
  )
}

resource "aws_security_group_rule" "workers_self" {
  type                      = "ingress"
  description               = "Allow nodes to communicate with each other."
  security_group_id         = aws_security_group.workers.id
  source_security_group_id  = aws_security_group.workers.id
  from_port                 = 0
  to_port                   = 0
  protocol                  = "-1"
}

resource "aws_security_group_rule" "workers_ingress_all_cluster" {
  description               = "Allow pods to receive communication from control plane."
  protocol                  = "tcp"
  security_group_id         = aws_security_group.workers.id
  source_security_group_id  = aws_security_group.cluster.id
  from_port                 = 1025
  to_port                   = 65535
  type                      = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_tls_cluster" {
  description               = "Allow pods to receive communication from control plane."
  protocol                  = "tcp"
  security_group_id         = aws_security_group.workers.id
  source_security_group_id  = aws_security_group.cluster.id
  from_port                 = 443
  to_port                   = 443
  type                      = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_ssh" {
  description               = "Allow ssh access from home."
  protocol                  = "tcp"
  security_group_id         = aws_security_group.workers.id
  from_port                 = 22
  to_port                   = 22
  cidr_blocks               = ["177.200.199.37/32"]
  type                      = "ingress"
}

resource "aws_security_group_rule" "workers_egress_tls_cluster" {
  description               = "Allow workers to reach control plane."
  protocol                  = "tcp"
  security_group_id         = aws_security_group.workers.id
  source_security_group_id  = aws_security_group.cluster.id
  from_port                 = 443
  to_port                   = 443
  type                      = "egress"
}

resource "aws_security_group_rule" "workers_egress_internet" {
  description               = "Allow nodes all egress to the Internet."
  from_port                 = 0
  to_port                   = 0
  protocol                  = "-1"
  security_group_id         = aws_security_group.workers.id
  cidr_blocks               = ["0.0.0.0/0"]
  ipv6_cidr_blocks          = ["::/0"]
  type                      = "egress"
}
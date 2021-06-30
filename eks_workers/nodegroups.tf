resource "aws_key_pair" "workers_key" {
  key_name   = "${local.name_prefix}-keypair-workers"
  public_key = var.public_key
  tags              = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-keypair-workers"
    },
    {
      Lifecycle = "Cluster applications"
    }
  )
}

resource "aws_launch_template" "workers" {
  
  name_prefix = "${local.name_prefix}-launchtemplate-workers"
  credit_specification {
    cpu_credits = "standard"
  }
  disable_api_termination = true
  ebs_optimized = true
  // instance_market_options {
  //   market_type = "spot"
  // }
  instance_type = var.workers_instance_type
  key_name = aws_key_pair.workers_key.key_name
  // metadata_options {
  //   http_endpoint               = "enabled"
  //   http_tokens                 = "required"
  //   http_put_response_hop_limit = 1
  // }
  monitoring {
    enabled = true
  }
  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination = true
    security_groups       = [data.aws_security_groups.workers.ids[0]]
  }
  tag_specifications {
    resource_type = "instance"
    tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-eks-worker"
    },
    {
      Lifecycle = "Autoscaling Resource"
    }
  )
  }
  tags              = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-launchtemplate-workers"
    },
    {
      Lifecycle = "Cluster NodeGroup"
    }
  )
}

resource "aws_eks_node_group" "workers" {
  cluster_name    = local.eks_cluster_name
  node_group_name_prefix = "${local.name_prefix}-eks-nodegroup-"
  node_role_arn   = aws_iam_role.workers.arn
  subnet_ids      = data.aws_subnet_ids.private.ids
  // capacity_type   = var.instance_type

  scaling_config {
    desired_size  = 1
    max_size      = 2
    min_size      = 1
  }

  launch_template {
    id            = aws_launch_template.workers.id
    version       = "$Latest"
  }

  // Block needed to ignore changes in the autoscaling config (triggered by k8s cluster autoscaler)
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  // taints {

  // }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-eks-nodegroup"
    },
    {
      Lifecycle = "Cluster NodeGroup"
    }
  )

  depends_on = [
    aws_launch_template.workers,
    aws_iam_role_policy_attachment.workers_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.workers_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.workers_AmazonEC2ContainerRegistryReadOnly
  ]
}
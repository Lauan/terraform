
resource "aws_launch_template" "workers" {
  name_prefix = var.enable_spot_instances ? "${local.name_prefix}-launchtemplate-workers-spot-" : "${local.name_prefix}-launchtemplate-workers-"
  disable_api_termination = true
  ebs_optimized = true
  instance_type = var.workers_instance_type
  key_name = "${local.name_prefix}-keypair-workers"
  monitoring {
    enabled = var.enable_instance_detailed_monitoring
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
      }
    )
  }
  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-launchtemplate-workers"
    }
  )
}

resource "aws_eks_node_group" "workers" {
  cluster_name    = local.eks_cluster_name
  node_group_name_prefix = var.enable_spot_instances ? "${local.name_prefix}-eks-nodegroup-spot-" : "${local.name_prefix}-eks-nodegroup-"
  node_role_arn   = data.aws_iam_role.workers.arn
  subnet_ids      = data.aws_subnet_ids.private.ids
  capacity_type   = var.enable_spot_instances ? "SPOT" : "ON_DEMAND"

  scaling_config {
    desired_size  = var.desired_instances
    max_size      = var.max_instances
    min_size      = var.min_instances
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
    }
  )
}
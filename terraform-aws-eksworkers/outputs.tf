output "nodegroup_name" {
  value = aws_eks_node_group.workers.node_group_name_prefix
}

output "capacity_type" {
  value = aws_eks_node_group.workers.capacity_type
}

output "instance_type" {
  value = aws_eks_node_group.workers.instance_types
}
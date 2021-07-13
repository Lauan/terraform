output "vpc_id" {
  value = module.network.vpc_id
}

output "vpc_cidr" {
  value = module.network.vpc_cidr
}

output "public_subnets"{
  value = module.network.public_subnets
}

output "private_subnets"{
  value = module.network.private_subnets
}

output "intra_subnets"{
  value = module.network.intra_subnets
}

output "cloudwatch_log_group_flowlogs_accept" {
  value = module.network.cloudwatch_log_group_flowlogs_accept
}

output "cloudwatch_log_group_flowlogs_reject" {
  value = module.network.cloudwatch_log_group_flowlogs_reject
}

output "vpc_flowlogs_reject_enabled" {
  value = module.network.vpc_flowlogs_reject_enabled
}

output "vpc_flowlogs_accept_enabled" {
  value = module.network.vpc_flowlogs_accept_enabled
}

output "s3_endpoint_enabled" {
  value = module.network.s3_endpoint_enabled
}

output "dynamodb_endpoint_enabled" {
  value = module.network.dynamodb_endpoint_enabled
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = var.vpc_cidr
}

output "eip_addresses" {
  value = {for k, v in aws_eip.eip : k => v.public_ip}
}

output "public_subnets"{
  value = {for k, v in aws_subnet.public_subnet : k => v.id}
}

output "private_subnets"{
value = {for k, v in aws_subnet.private_subnet : k => v.id}
}

output "intra_subnets"{
value = {for k, v in aws_subnet.intra_subnet : k => v.id}
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  value = {for k, v in aws_nat_gateway.natgw : k => v.id}
}

output "cloudwatch_log_group_flowlogs_accept" {
  value = aws_cloudwatch_log_group.accept.*.name
}

output "cloudwatch_log_group_flowlogs_reject" {
  value = aws_cloudwatch_log_group.reject.*.name
}

output "vpc_flowlogs_reject_enabled" {
  value = var.enable_reject_flowlogs
}

output "vpc_flowlogs_accept_enabled" {
  value = var.enable_accept_flowlogs
}

output "s3_endpoint_enabled" {
  value = var.enable_s3_endpoint
}

output "dynamodb_endpoint_enabled" {
  value = var.enable_dynamodb_endpoint
}
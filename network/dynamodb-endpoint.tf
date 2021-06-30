resource "aws_vpc_endpoint" "dynamodb" {
  count             = var.enable_dynamodb_endpoint ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.ca-central-1.dynamodb"
  tags              = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-dynamo-endpoint"
    },
    {
      Lifecycle = "Common Infrasctructure"
    }
  )
}

resource "aws_vpc_endpoint_route_table_association" "private_dynamodb"{
  count                 = var.enable_dynamodb_endpoint ? length(var.private_subnets) : 0
  vpc_endpoint_id       = aws_vpc_endpoint.dynamodb[0].id
  route_table_id        = var.single_natgw ? aws_route_table.private[0].id : element(aws_route_table.private.*.id, count.index)
}
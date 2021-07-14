resource "aws_vpc_endpoint" "s3" {
  count             = var.enable_s3_endpoint ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.ca-central-1.s3"
  tags              = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-s3-endpoint"
    },
    {
      Lifecycle = "Common Infrasctructure"
    }
  )
}

resource "aws_vpc_endpoint_route_table_association" "private_s3"{
  count                 = var.enable_s3_endpoint ? length(var.private_subnets) : 0
  vpc_endpoint_id       = aws_vpc_endpoint.s3[0].id
  route_table_id        = var.single_natgw ? aws_route_table.private[0].id : element(aws_route_table.private.*.id, count.index)
}
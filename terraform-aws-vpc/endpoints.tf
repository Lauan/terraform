// S3 Endpoint
resource "aws_vpc_endpoint" "s3" {
  for_each             = var.enable_s3_endpoint ? toset(["s3_endpoint"]) : toset([])
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
  for_each              = var.enable_s3_endpoint ? aws_route_table.private : tomap({})
  vpc_endpoint_id       = aws_vpc_endpoint.s3["s3_endpoint"].id
  route_table_id        = each.value.id
}

// DynamoDB Endpoint
resource "aws_vpc_endpoint" "dynamodb" {
  for_each          = var.enable_dynamodb_endpoint ? toset(["dynamo_endpoint"]) : toset([])
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
  for_each              = var.enable_dynamodb_endpoint ? aws_route_table.private : tomap({})
  vpc_endpoint_id       = aws_vpc_endpoint.dynamodb["dynamo_endpoint"].id
  route_table_id        = each.value.id
}
//Create the point to create the Route Table
resource "aws_route_table" "intra" {
  vpc_id               = aws_vpc.vpc.id
  tags                 = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-rt-intra"
    },
    {
      Lifecycle = "Common Infrasctructure"
    },
    {
      Tier = "private"
    }
  )
}

// Create the Intra Subnet
resource "aws_subnet" "intra_subnet" {
  for_each              = local.intra_sn_idx_map
  vpc_id                = aws_vpc.vpc.id
  cidr_block            = each.key
  availability_zone     = element(data.aws_availability_zones.azs.names, var.dual_az_only ? each.value % 2 : each.value % length(data.aws_availability_zones.azs.names))
  tags                  = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-sn-intra-${each.value}"
    },
    {
      Lifecycle = "Common Infrasctructure"
    },
    {
      Tier = "isolated"
    }
  )
}
// Associate the Route Table(s) to the intra subnets
resource "aws_route_table_association" "intra" {
  for_each              = aws_subnet.intra_subnet
  subnet_id             = each.value.id
  route_table_id        = aws_route_table.intra.id
}
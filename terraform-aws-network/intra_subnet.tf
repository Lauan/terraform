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
  count                 = length(var.intra_subnets)
  vpc_id                = aws_vpc.vpc.id
  cidr_block            = element(var.intra_subnets, count.index)
  availability_zone     = element(data.aws_availability_zones.azs.names, var.dual_az_only ? count.index % 2 : count.index % length(data.aws_availability_zones.azs.names))
  tags                  = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-sn-intra-${count.index}"
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
  count                 = length(var.intra_subnets)
  subnet_id             = element(aws_subnet.intra_subnet.*.id, count.index)
  route_table_id        = aws_route_table.intra.id
}
// Create EIP
resource "aws_eip" "eip" {
  for_each = var.single_natgw ? local.single_idx_map : local.private_sn_idx_map

  depends_on          = [aws_internet_gateway.igw]
  vpc                 = true
  tags                = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-eip-${each.value}"
    },
    {
      Lifecycle = "Common Infrasctructure"
    },
    {
      Tier = "private"
    }
  )
}

//Create Nat Gateway
resource "aws_nat_gateway" "natgw" {
  for_each = var.single_natgw ? local.single_idx_map : local.private_sn_idx_map

  allocation_id       = aws_eip.eip[each.key].id
  subnet_id           = aws_subnet.public_subnet[element(var.public_subnets,each.value)].id
  depends_on          = [aws_internet_gateway.igw]
  tags                = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-natgw-${each.value}"
    },
    {
      Lifecycle = "Common Infrasctructure"
    },
    {
      Tier = "private"
    }
  )
}
//Create the point to create the Route Table
resource "aws_route_table" "private" {
  for_each             = var.single_natgw ? local.single_idx_map : local.private_sn_idx_map
  vpc_id               = aws_vpc.vpc.id
  tags                 = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-rt-private-${each.value}"
    },
    {
      Lifecycle = "Common Infrasctructure"
    },
    {
      Tier = "private"
    }
  )
}
// Create the Routes in the Route Table
resource "aws_route" "private_routes" {
  for_each               = var.single_natgw ? local.single_idx_map : local.private_sn_idx_map
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw[each.key].id
  depends_on             = [aws_nat_gateway.natgw]
}

// Create the Private Subnet
resource "aws_subnet" "private_subnet" {
  for_each              = local.private_sn_idx_map
  vpc_id                = aws_vpc.vpc.id
  cidr_block            = each.key
  availability_zone     = element(data.aws_availability_zones.azs.names, var.dual_az_only ? each.value % 2 : each.value % length(data.aws_availability_zones.azs.names))
  tags                  = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-sn-private-${each.value}"
    },
    {
      Lifecycle = "Common Infrasctructure"
    },
    {
      Tier = "private"
    }
  )
}
// Associate the Route Table(s) to the private subnets
resource "aws_route_table_association" "private" {
  for_each              = local.private_sn_idx_map
  subnet_id             = aws_subnet.private_subnet[each.key].id
  route_table_id        = var.single_natgw ? aws_route_table.private[element(keys(local.single_idx_map),0)].id : aws_route_table.private[each.key].id
}
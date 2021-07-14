// Create EIP
resource "aws_eip" "eip" {
  count = var.single_natgw ? 1 : length(var.public_subnets)

  depends_on          = [aws_internet_gateway.igw]
  vpc                 = true
  tags                = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-eip-${count.index}"
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
  count = var.single_natgw ? 1 : length(var.public_subnets)

  allocation_id       = element(aws_eip.eip.*.id, count.index)
  subnet_id           = element(aws_subnet.public_subnet.*.id, count.index)
  depends_on          = [aws_internet_gateway.igw]
  tags                = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-natgw-${count.index}"
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
  count = var.single_natgw ? 1 : length(var.public_subnets)
  vpc_id               = aws_vpc.vpc.id
  tags                 = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-rt-private-${count.index}"
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
  count                  = var.single_natgw ? 1 : length(var.public_subnets)
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.natgw.*.id, count.index)
  depends_on             = [aws_nat_gateway.natgw]
}

// Create the Private Subnet
resource "aws_subnet" "private_subnet" {
  count                 = length(var.private_subnets)
  vpc_id                = aws_vpc.vpc.id
  cidr_block            = element(var.private_subnets, count.index)
  availability_zone     = element(data.aws_availability_zones.azs.names, var.dual_az_only ? count.index % 2 : count.index % length(data.aws_availability_zones.azs.names))
  tags                  = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-sn-private-${count.index}"
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
  count                 = length(var.private_subnets)
  subnet_id             = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id        = var.single_natgw ? aws_route_table.private[0].id : element(aws_route_table.private.*.id, count.index)
}
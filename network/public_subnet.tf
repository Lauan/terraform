// Create the Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id                  = aws_vpc.vpc.id
  tags                    = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-igw"
    },
    {
      Lifecycle = "Common Infrasctructure"
    }
  )
}

// Create the Route table
resource "aws_route_table" "public" {
  vpc_id                  = aws_vpc.vpc.id
  tags                    = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-rt-public"
    },
    {
      Lifecycle = "Common Infrasctructure"
    },
    {
      Tier = "public"
    }
  )
}

// Create the point to create the Route Table
resource "aws_route" "public_routes" {
  route_table_id          = aws_route_table.public.id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.igw.id
}

// Create the Public Subnet
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(data.aws_availability_zones.azs.names, var.dual_az_only ? count.index % 2 : count.index % length(data.aws_availability_zones.azs.names))
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags                    = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-sn-public-${count.index}"
    },
    {
      Lifecycle = "Common Infrasctructure"
    },
    {
      Tier = "public"
    }
  )
}

// Create the Route Table

resource "aws_route_table_association" "public" {
  count                   = length(var.public_subnets)
  subnet_id               = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id          = aws_route_table.public.id
}
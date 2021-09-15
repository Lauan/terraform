resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.vpc.id
  subnet_ids = [for k, v in aws_subnet.private_subnet : v.id]
  tags                  = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-nacl-private"
    },
    {
      Lifecycle = "Common Infrasctructure"
    },
    {
      Tier = "private"
    }
  )
}

// Allow all traffic from VPC
resource "aws_network_acl_rule" "private_ingress" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr
  from_port      = 0
  to_port        = 0
}

// Allow traffic on high ports (for EKS nodes to receve traffic from the API), except known ports
resource "aws_network_acl_rule" "private_ingress1" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "private_egress" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "extra_private_rules" {
  for_each       = var.extra_private_acl
  network_acl_id = aws_network_acl.private.id
  rule_number    = lookup(each.value, "rule_number")
  egress         = lookup(each.value, "is_egress")
  protocol       = lookup(each.value, "rule_protocol")
  rule_action    = lookup(each.value, "rule_action", "allow")
  cidr_block     = lookup(each.value, "cidr_block")
  from_port      = lookup(each.value, "from_port")
  to_port        = lookup(each.value, "to_port")
}

////////////////////////////////
//  PUBLIC NETWORK ACL
////////////////////////////////

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.vpc.id
  subnet_ids = [for k, v in aws_subnet.public_subnet : v.id]
  tags                  = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-nacl-public"
    },
    {
      Lifecycle = "Common Infrasctructure"
    },
    {
      Tier = "public"
    }
  )
}

resource "aws_network_acl_rule" "public_rules" {
  for_each       = var.public_acl
  network_acl_id = aws_network_acl.public.id
  rule_number    = lookup(each.value, "rule_number")
  egress         = lookup(each.value, "egress")
  protocol       = lookup(each.value, "protocol")
  rule_action    = lookup(each.value, "rule_action", "allow")
  cidr_block     = lookup(each.value, "cidr_block")
  from_port      = lookup(each.value, "from_port")
  to_port        = lookup(each.value, "to_port")
}
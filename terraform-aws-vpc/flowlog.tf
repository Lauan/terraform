//KMS FOR CLOUD WATCH LOGS GROUP
resource "aws_kms_key" "vpc-flow-log" {
  count                     = var.enable_accept_flowlogs || var.enable_reject_flowlogs ? 1 : 0
  description               = "KMS FOR VPC FLOW LOGS REJECT"
  deletion_window_in_days   = 10
  enable_key_rotation       = true
  policy                    = data.aws_iam_policy_document.kms_key_policy.json
  tags                      = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-kms-flowlog-key"
    },
    {
      Lifecycle = "Common Infrasctructure"
    }
  )
}

// CREATE ROLE FOR VPC FLOW LOG
resource "aws_iam_role" "flow_logs" {
  count              = var.enable_accept_flowlogs || var.enable_reject_flowlogs ? 1 : 0
  name               = "vpc-flow-logs"
  description        = "Allow VPC Flow Log to Put LogEvents"
  assume_role_policy = data.aws_iam_policy_document.flow_logs_role.json
  tags               = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-iam-role-flow-logs"
    },
    {
      Lifecycle = "Common Infrasctructure"
    }
  )
}

//CREATE POLICY FOR ROLE VPC-FLOW-LOG
resource "aws_iam_role_policy" "flow_logs" {
  count              = var.enable_accept_flowlogs || var.enable_reject_flowlogs ? 1 : 0
  name               = "vpc-flow-logs"
  role               = aws_iam_role.flow_logs[0].id
  policy             = data.aws_iam_policy_document.flow_logs_policy.json
}

// CREATE VPC FLOW LOG - REJECT
resource "aws_flow_log" "reject" {
  count             = var.enable_reject_flowlogs ? 1 : 0
  iam_role_arn      = aws_iam_role.flow_logs[0].arn
  log_destination   = aws_cloudwatch_log_group.reject[0].arn
  traffic_type      = "REJECT"
  vpc_id            = aws_vpc.vpc.id
  tags              = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-flowlog-reject"
    },
    {
      Lifecycle = "Common Infrasctructure"
    }
  )
}

// CREATE VPC FLOW LOG - ACCEPT
resource "aws_flow_log" "accept" {
  count             = var.enable_accept_flowlogs ? 1 : 0
  iam_role_arn      = aws_iam_role.flow_logs[0].arn
  log_destination   = aws_cloudwatch_log_group.accept[0].arn
  traffic_type      = "ACCEPT"
  vpc_id            = aws_vpc.vpc.id
  tags              = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-flowlog-accept"
    },
    {
      Lifecycle = "Common Infrasctructure"
    }
  )
}

// CREATE LOG GROUP VPC FLOW LOG REJECT
resource "aws_cloudwatch_log_group" "reject" {
  count             = var.enable_reject_flowlogs ? 1 : 0
  name              = "VPC-FLOW-LOG-REJECT"
  retention_in_days = 7
  kms_key_id        = aws_kms_key.vpc-flow-log[0].arn
  tags              = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-cloudwatch-loggroup-reject"
    },
    {
      Lifecycle = "Common Infrasctructure"
    }
  )
}

// CREATE LOG GROUP VPC FLOW LOG ACCEPT
resource "aws_cloudwatch_log_group" "accept" {
  count             = var.enable_accept_flowlogs ? 1 : 0
  name              = "VPC-FLOW-LOG-ACCEPT"
  retention_in_days = 7
  kms_key_id        = aws_kms_key.vpc-flow-log[0].arn
  tags              = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-cloudwatch-loggroup-accept"
    },
    {
      Lifecycle = "Common Infrasctructure"
    }
  )
}
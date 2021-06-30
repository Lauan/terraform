// Get the avaliability zones in the provider's region that have the state as 'avaliable'
data "aws_availability_zones" "azs" {
  state = "available"
}

// Generate a Flow Logs policy json
data "aws_iam_policy_document" "flow_logs_policy" {
  statement {
    sid = "FlowLogsPolicy"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = ["*"]
  }
}

// Generate a Flow Logs Role policy json
data "aws_iam_policy_document" "flow_logs_role" {
  statement {
    sid = "FlowLogsServiceRole"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

// Generate a KMS Key policy to allow log encryption
data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    sid = "AccountKMSAccess"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
    }
    actions = [
      "kms:*"
    ]
    resources = ["*"]
  }
  statement {
    sid = "LogServicesKMSAccess"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    principals {
      type        = "Service"
      identifiers = ["logs.${var.region}.amazonaws.com"]
    }
    condition {
      test     = "ArnLike"
      variable = "kms:EncryptionContext:aws:logs:arn"

      values = [
        "arn:aws:logs:${var.region}:${var.account_id}:*"
      ]
    }
    resources = ["*"]
  }
}
////////////////////////////////////
// ACCOUNT                        
////////////////////////////////////

// Get AWS Partition details
data "aws_partition" "current" {}

// Get Account ID
data "aws_caller_identity" "current" {}

////////////////////////////////////
// NETWORK / SECURITY             
////////////////////////////////////

// Get VPC ID (set of IDs, must be turn into a list using 'tolist')
data "aws_vpcs" "main" {
  tags = {
    Application         = var.application
    Environment         = var.environment
  }
}

// Get Private Subnet IDs (List of IDs)
data "aws_subnet_ids" "private" {
  vpc_id = tolist(data.aws_vpcs.main.ids)[0]

  tags = {
    Tier = "private"
  }
}

// Get Public Subnet IDs (List of IDs)
data "aws_subnet_ids" "public" {
  vpc_id = tolist(data.aws_vpcs.main.ids)[0]

  tags = {
    Tier = "public"
  }
}

////////////////////////////////////
// IAM
////////////////////////////////////

// Generate a EKS cluster role policy json
data "aws_iam_policy_document" "cluster_role" {
  statement {
    sid = "EKSClusterAssumeRole"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

// Generate a EKS worker role policy json
data "aws_iam_policy_document" "workers_role" {
  statement {
    sid = "EKSWorkerAssumeRole"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

// Generate a KMS Key policy to allow log encryption
data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    sid = "AccountKMSAccess"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
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
        "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
      ]
    }
    resources = ["*"]
  }
}
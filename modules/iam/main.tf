

variable "table_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "account" {
  type = string
}

data "aws_iam_policy" "BasicLambdaExecution" {
  name = "AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "lambda_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:DeleteItem",
      "dynamodb:Query",
      "dynamodb:Scan",
    ]
    resources = ["arn:aws:dynamodb:${var.region}:${var.account}:table/${var.table_name}"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameter"]
    resources = ["arn:aws:ssm:${var.region}:${var.account}:parameter/pssst/${var.environment}/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["lambda:InvokeFunction"]
    resources = ["arn:aws:lambda:${var.region}:${var.account}:function:pssst-${var.environment}"]
  }

  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "pssst_role" {
  name                = "pssst-role-${var.environment}"
  path                = "/service-role/"
  managed_policy_arns = [data.aws_iam_policy.BasicLambdaExecution.arn]
  assume_role_policy  = data.aws_iam_policy_document.lambda_trust_policy.json
  inline_policy {
    name   = "pssst_inline_policy"
    policy = data.aws_iam_policy_document.lambda_policy.json
  }
}

output "data" {
  value = {
    role_arn = aws_iam_role.pssst_role.arn
  }
}
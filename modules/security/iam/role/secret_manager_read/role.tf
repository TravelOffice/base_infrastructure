variable "ENV" {}
variable "FEATURE_NAME" {}
variable "TAGS" {}
variable "RESOURCE" {}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "policy" {
  name = "${var.ENV}-${var.FEATURE_NAME}-secret_manager_read_only"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ]
        Effect   = "Allow"
        Resource = var.RESOURCE
      },
    ]
  })
}

resource "aws_iam_role" "role" {
  name                = "${var.ENV}-${var.FEATURE_NAME}-secret_manager_read_only"
  assume_role_policy  = data.aws_iam_policy_document.lambda_assume_role_policy.json
  managed_policy_arns = [aws_iam_policy.policy.arn]

  tags = var.TAGS
}

output "id" {
  value = aws_iam_role.role.id
}
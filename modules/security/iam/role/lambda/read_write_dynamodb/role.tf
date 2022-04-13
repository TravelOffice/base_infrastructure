variable "ENV" {}
variable "FEATURE_NAME" {}
variable "TAGS" {}
variable "DYNAMO_TABLE_ARN" {}

resource "aws_iam_policy" "policy" {
  name = "${var.ENV}-${var.FEATURE_NAME}-read-write-dynamodb"

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
        Resource = "*"
      },
      {
        Action = [
          "ec2:DescribeInstances",
          "ec2:CreateNetworkInterface",
          "ec2:AttachNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "autoscaling:CompleteLifecycleAction"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*",
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ],
        "Resource" : [
          "${var.DYNAMO_TABLE_ARN}",
          "${var.DYNAMO_TABLE_ARN}/index/*"
        ]
      },
      {
        Action = [
          "ses:SendMail"
        ]
        Effect   = "Allow"
        Resource = "*",
      }
    ]
  })
}

resource "aws_iam_role" "role" {
  name_prefix = "${var.ENV}-${var.FEATURE_NAME}-read-write-dynamodb"
  tags        = var.TAGS
  path        = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          "Service" : "lambda.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [aws_iam_policy.policy.arn]
}

output "arn" {
  value = aws_iam_role.role.arn
}

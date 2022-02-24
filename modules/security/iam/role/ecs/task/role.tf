variable "ENV" {}
variable "FEATURE_NAME" {}
variable "TAGS" {}
resource "aws_iam_policy" "invoke_lambda_policy" {
  name = "${var.ENV}-${var.FEATURE_NAME}-ecs-invoke-lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "1",
        "Effect" : "Allow",
        "Action" : "lambda:InvokeFunction",
        "Resource" : "arn:aws:lambda:ap-southeast-1:249593777629:function:${var.ENV}-${var.FEATURE_NAME}-*"
      }
    ]
  })
}


resource "aws_iam_role" "role" {
  name_prefix = "${var.ENV}-${var.FEATURE_NAME}-task-execution"
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
          "Service" : "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    aws_iam_policy.invoke_lambda_policy.arn
  ]
}

output "arn" {
  value = aws_iam_role.role.arn
}

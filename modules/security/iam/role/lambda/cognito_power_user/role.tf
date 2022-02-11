variable "ENV" {}
variable "FEATURE_NAME" {}
variable "TAGS" {}

resource "aws_iam_role" "role" {
  name_prefix = "${var.ENV}-${var.FEATURE_NAME}-cognito-power-user"
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
    "arn:aws:iam::aws:policy/AmazonCognitoPowerUser",
  ]
}

output "arn" {
  value = aws_iam_role.role.arn
}

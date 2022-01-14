data "aws_iam_policy_document" "policy_document" {
  statement {
    sid = "BaseAccess"

    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]

    resources = ["arn:aws:secretsmanager:*:249593777629:secret:%s"] # Secret manager id will be input in feature project
    effect    = "Allow"
  }
}

output policy_json {
    value = data.aws_iam_policy_document.policy_document.json
}
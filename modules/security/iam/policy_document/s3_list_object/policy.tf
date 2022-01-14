data "aws_iam_policy_document" "policy_document" {
  statement {
    sid = "BaseAccess"

    actions = [
      "s3:ListBucket",
      "s3:ListBucketVersions"
    ]

    resources = ["arn:aws:s3:::bucketname"]
    effect    = "Allow"
  }
}

output policy_json {
    value = data.aws_iam_policy_document.policy_document.json
}
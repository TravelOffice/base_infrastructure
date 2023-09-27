variable "ENV" {}
variable "SNS_TOPIC_NAME" {}
variable "SUBSCRIPTION_ENDPOINT" {}
variable "PROTOCOL" {
  default = "sqs"
}
variable "TAGS" {}

resource "aws_sns_topic" "topic" {
  name = "${var.ENV}-${var.SNS_TOPIC_NAME}"
  tags = var.TAGS
}

resource "aws_sns_topic_subscription" "subscription" {
  topic_arn              = aws_sns_topic.topic.arn
  protocol               = var.PROTOCOL
  endpoint               = var.SUBSCRIPTION_ENDPOINT
  endpoint_auto_confirms = true
}

output "topic_arn" {
  value = aws_sns_topic.topic.arn
}

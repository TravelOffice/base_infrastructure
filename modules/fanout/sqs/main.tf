variable "ENV" {}
variable "NAME" {}
variable "TAGS" {}
variable "DELAY_SECONDS" {
  default = 0
}
variable "MAX_MESSAGE_SIZE" {
  default = 262144 # 256 KiB
}
variable "MESSAGE_RETENTION_SECONDS" {
  default = 345600 # 4 days
}
variable "RECEIVE_WAIT_TIME_SECONDS" {
  default = 0
}
resource "aws_sqs_queue" "queue" {
  name                      = "${var.ENV}-${var.NAME}"
  delay_seconds             = var.DELAY_SECONDS
  max_message_size          = var.MAX_MESSAGE_SIZE
  message_retention_seconds = var.MESSAGE_RETENTION_SECONDS
  receive_wait_time_seconds = var.RECEIVE_WAIT_TIME_SECONDS

  tags = var.TAGS
}

output "arn" {
  value = aws_sqs_queue.queue.arn
}

output "url" {
  value = aws_sqs_queue.queue.url
}

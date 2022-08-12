variable "ENV" {}
variable "TAGS" {}

locals {
  queue_name = "${var.ENV}-new_conversation_queue"
}

resource "aws_sqs_queue" "new_conversation_queue" {
  # Queue name
  name_prefix                     = local.queue_name
  # Is fifo queue or not
  fifo_queue                      = true
  # Enables content-based deduplication for FIFO queues
  content_based_deduplication     = true
  # The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning.
  # An integer from 0 to 20 (seconds).
  receive_wait_time_seconds       = 5

  # Policy as object
  policy                          = jsonencode({})

  tags = var.TAGS
}

output "new_conversation_queue_arn" {
  value = aws_sqs_queue.new_conversation_queue.arn
}
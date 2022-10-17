variable "ENV" {}
variable "TAGS" {}
variable "AWS_REGION" {}

resource "aws_ebs_volume" "volume" {
  availability_zone = "${var.AWS_REGION}a"
  size              = var.ENV == "dev" ? 40 : 100
  final_snapshot    = true
  type              = "gp3"
  encrypted         = true

  tags = var.TAGS
}

output "volume_id" {
  value = aws_ebs_volume.volume.id
}

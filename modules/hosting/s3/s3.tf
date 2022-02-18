variable "BUCKET_PREFIX" {
  type = string
}

variable "TAGS" {}

variable "ACL" {
  default = "private"
}

resource "aws_s3_bucket" "tf_bucket" {
  acl           = var.ACL
  bucket_prefix = var.BUCKET_PREFIX

  versioning {
    enabled = false
  }
}

output "arn" {
  value = aws_s3_bucket.tf_bucket.arn
}

output "domain" {
  value = aws_s3_bucket.tf_bucket.bucket_domain_name
}
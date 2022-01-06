variable "BUCKET_PREFIX" {
  type = string
}

variable "ACL" {
  default = "private"
}

resource "aws_s3_bucket" "tf_bucket" {
  acl           = var.ACL
  bucket_prefix = var.BUCKET_PREFIX

  versioning {
    enabled = true
  }
}

output "id" {
  value = aws_s3_bucket.tf_bucket.id
}
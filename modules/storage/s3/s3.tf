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


resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.tf_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "arn" {
  value = aws_s3_bucket.tf_bucket.arn
}

output "domain" {
  value = aws_s3_bucket.tf_bucket.bucket_domain_name
}

output "id" {
  value = aws_s3_bucket.tf_bucket.id
}
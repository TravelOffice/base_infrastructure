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


resource "aws_s3_bucket_public_access_block" "allow_public_access" {
  bucket = aws_s3_bucket.tf_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_cors_configuration" "allow_cors_s3" {
  bucket = aws_s3_bucket.tf_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_origins = ["*"]
    allowed_methods = ["HEAD", "GET", "POST", "PUT", "DELETE"]
    expose_headers  = ["ETag", "x-amz-meta-custom-header"]
    max_age_seconds = 3000
  }

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
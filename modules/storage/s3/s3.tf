variable "BUCKET_PREFIX" {
  type = string
}

variable "TAGS" {}

variable "ACL" {
  default = "private"
}

variable "BLOCK_PUBLIC_ACCESS" {
  default = true
}

resource "aws_s3_bucket" "tf_bucket" {
  bucket_prefix = var.BUCKET_PREFIX
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.tf_bucket.id
  acl    = var.ACL
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.tf_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_public_access_block" "allow_public_access" {
  bucket = aws_s3_bucket.tf_bucket.id

  block_public_acls       = var.BLOCK_PUBLIC_ACCESS
  block_public_policy     = var.BLOCK_PUBLIC_ACCESS
  ignore_public_acls      = var.BLOCK_PUBLIC_ACCESS
  restrict_public_buckets = var.BLOCK_PUBLIC_ACCESS
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

output "bucket_regional_domain_name" {
  value = "https://${aws_s3_bucket.tf_bucket.bucket_regional_domain_name}"
}
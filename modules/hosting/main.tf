variable "BUCKET_PREFIX" {}
variable "ACM" {}
variable "ALIASES" {}
variable "DEFAULT_ROOT_OBJECT" {
  default = "index.html"
}
variable "BLOCK_PUBLIC_ACCESS" {
  default = true
}
variable "TAGS" {}

module "s3_bucket" {
  source        = "../storage/s3"
  BUCKET_PREFIX = var.BUCKET_PREFIX
  TAGS          = var.TAGS
}

module "cdn" {
  source              = "./cloudfront"
  S3_BUCKET           = module.s3_bucket
  ACM                 = var.ACM
  ALIASES             = var.ALIASES
  DEFAULT_ROOT_OBJECT = var.DEFAULT_ROOT_OBJECT
  TAGS                = var.TAGS
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.s3_bucket.id
  policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "AllowPublicUpload",
          "Effect": "Allow",
          "Principal": "*",
          "Action": "s3:PutObject",
          "Resource": "${module.s3_bucket.arn}/*"
        },
        {
          "Sid": "AllowCloudFrontServicePrincipal",
          "Effect": "Allow",
          "Principal": {
              "Service": "cloudfront.amazonaws.com"
          },
          "Action": "s3:GetObject",
          "Resource": "${module.s3_bucket.arn}/*",
          "Condition": {
            "StringEquals": {
              "AWS:SourceArn": "${module.cdn.arn}"
            }
          }
        }
      ]
    }
  EOF
}

resource "aws_s3_bucket_public_access_block" "allow_public_access" {
  bucket = module.s3_bucket.id

  block_public_acls       = var.BLOCK_PUBLIC_ACCESS
  block_public_policy     = var.BLOCK_PUBLIC_ACCESS
  ignore_public_acls      = var.BLOCK_PUBLIC_ACCESS
  restrict_public_buckets = var.BLOCK_PUBLIC_ACCESS
  depends_on = [
    aws_s3_bucket_policy.bucket_policy
  ]
}

output "s3_id" {
  value = module.s3_bucket.id
}

output "cdn_domain" {
  value = module.cdn.domain
}

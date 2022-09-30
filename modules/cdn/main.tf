variable "S3_BUCKET" {}
variable "ACM" {}
variable "DEFAULT_ROOT_OBJECT" {
  default = ""
}
variable "ALIASES" {}
variable "HOSTED_ZONE_ID" {}
variable "RECORD_NAME" {}
variable "CUSTOM_HEADER_ID" {}
variable "TAGS" {}

module "cloudfront_distribution" {
  source              = "../hosting/cloudfront"
  S3_BUCKET           = var.S3_BUCKET
  ACM                 = var.ACM
  DEFAULT_ROOT_OBJECT = var.DEFAULT_ROOT_OBJECT
  ALIASES             = var.ALIASES
  CUSTOM_HEADER_ID    = var.CUSTOM_HEADER_ID
  TAGS                = var.TAGS
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.S3_BUCKET.id
  policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "AllowPublicUpload",
          "Effect": "Allow",
          "Principal": "*",
          "Action": "s3:PutObject",
          "Resource": "${var.S3_BUCKET.arn}/*"
        },
        {
          "Sid": "AllowCloudFrontServicePrincipal",
          "Effect": "Allow",
          "Principal": {
              "Service": "cloudfront.amazonaws.com"
          },
          "Action": "s3:GetObject",
          "Resource": "${var.S3_BUCKET.arn}/*",
          "Condition": {
            "StringEquals": {
              "AWS:SourceArn": "${module.cloudfront_distribution.arn}"
            }
          }
        }
      ]
    }
  EOF
}

// Add DNS record for Cloudfront
resource "aws_route53_record" "www" {
  zone_id = var.HOSTED_ZONE_ID
  name    = var.RECORD_NAME
  type    = "CNAME"
  ttl     = "300"
  records = [module.cloudfront_distribution.domain]
}

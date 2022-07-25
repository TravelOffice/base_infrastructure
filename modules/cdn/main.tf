variable "S3_BUCKET" {}
variable "ACM" {}
variable "DEFAULT_ROOT_OBJECT" {
  default = ""
}
variable "ALIASES" {}
variable "HOSTED_ZONE_ID" {}
variable "RECORD_NAME" {}
variable "ALLOW_S3_ACTION" {}
variable "TAGS" {}

module "sale_chat_attachment_cdn" {
  source              = "../hosting/cloudfront"
  S3_BUCKET           = var.S3_BUCKET
  ACM                 = var.ACM
  DEFAULT_ROOT_OBJECT = var.DEFAULT_ROOT_OBJECT
  ALLOW_S3_ACTION     = var.ALLOW_S3_ACTION
  ALIASES             = var.ALIASES
  TAGS                = var.TAGS
}

resource "aws_s3_bucket_policy" "allow_access_from_cloudfront_to_s3" {
  bucket = var.S3_BUCKET.id
  policy = <<EOF
    {
      "Version": "2008-10-17",
      "Id": "PolicyForCloudFrontPrivateContent",
      "Statement": [
        {
          "Sid": "1",
          "Effect": "Allow",
          "Principal": {
              "AWS": "${module.sale_chat_attachment_cdn.arn}"
          },
          "Action": "s3:GetObject",
          "Resource": "${var.S3_BUCKET.arn}/*"
        },
        {
          "Sid": "2",
          "Effect": "Allow",
          "Principal": "*",
          "Action": "s3:PutObject",
          "Resource": "${var.S3_BUCKET.arn}/*"
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
  records = [module.sale_chat_attachment_cdn.domain]
}

variable "S3_BUCKET" {}
variable "ACM" {}
variable "DEFAULT_ROOT_OBJECT" {
  default = ""
}
variable "ALIASES" {}
variable "HOSTED_ZONE_ID" {}
variable "RECORD_NAME" {}
variable "TAGS" {}

module "sale_chat_attachment_cdn" {
  source              = "../hosting/cloudfront"
  S3_BUCKET           = var.S3_BUCKET
  ACM                 = var.ACM
  DEFAULT_ROOT_OBJECT = var.DEFAULT_ROOT_OBJECT
  ALIASES             = var.ALIASES
  TAGS                = var.TAGS
}

// Add DNS record for Cloudfront
resource "aws_route53_record" "www" {
  zone_id = var.HOSTED_ZONE_ID
  name    = var.RECORD_NAME
  type    = "CNAME"
  ttl     = "300"
  records = [module.sale_chat_attachment_cdn.domain]
}
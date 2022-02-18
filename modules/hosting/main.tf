variable "BUCKET_PREFIX" {}
variable "TAGS" {}

module "s3_bucket" {
  source        = "./s3"
  BUCKET_PREFIX = var.BUCKET_PREFIX
  TAGS          = var.TAGS
}

module "cdn" {
  source    = "./cloudfront"
  S3_BUCKET = module.s3_bucket
}

output "s3_id" {
  value = module.s3_bucket.id
}

output "cdn_domain" {
  value = module.cdn.domain
}
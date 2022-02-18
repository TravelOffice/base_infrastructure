variable "BUCKET_PREFIX" {}
variable "TAGS" {}

module "s3_bucket" {
  source        = "./s3"
  BUCKET_PREFIX = var.BUCKET_PREFIX
  TAGS          = var.TAGS
}

module "cdn" {
  source = "./cloudfront"
  S3_BUCKET = module.s3_bucket
}
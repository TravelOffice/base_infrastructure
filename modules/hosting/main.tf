variable "BUCKET_PREFIX" {}
variable "ACM" {}
variable "ALIASES" {}
variable "DEFAULT_ROOT_OBJECT" {
  default = "index.html"
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

output "s3_id" {
  value = module.s3_bucket.id
}

output "cdn_domain" {
  value = module.cdn.domain
}
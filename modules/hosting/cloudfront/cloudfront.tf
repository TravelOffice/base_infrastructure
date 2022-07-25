variable "S3_BUCKET" {}
variable "ACM" {}
variable "ALIASES" {}
variable "DEFAULT_ROOT_OBJECT" {
  default = "index.html"
}
variable "ALLOW_S3_ACTION" {
  default = []
}
variable "TAGS" {}

module "cdn" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "2.9.3"

  aliases                       = var.ALIASES
  default_root_object           = "index.html"
  enabled                       = true
  create_origin_access_identity = true
  origin_access_identities = {
    s3_bucket_one = "CloudFront can access to s3 bucket"
  }

  origin = {
    s3_one = {
      domain_name = var.S3_BUCKET.domain
      s3_origin_config = {
        origin_access_identity = "s3_bucket_one"
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3_one"
    viewer_protocol_policy = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/static/*"
      target_origin_id       = "s3_one"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      query_string    = true
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = var.ACM
    ssl_support_method  = "sni-only"
  }

  custom_error_response = [
    {
      error_caching_min_ttl = 10
      error_code            = 403
      response_code         = 200
      response_page_path    = "/index.html"
    }
  ]

  tags = var.TAGS
}

data "aws_iam_policy_document" "allow_access_from_cloudfront_to_s3" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["${module.cdn.cloudfront_origin_access_identity_iam_arns[0]}"]
    }

    actions = var.ALLOW_S3_ACTION

    resources = [
      "${var.S3_BUCKET.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_cloudfront_to_s3" {
  bucket = var.S3_BUCKET.id
  policy = data.aws_iam_policy_document.allow_access_from_cloudfront_to_s3.json
}

output "domain" {
  value = module.cdn.cloudfront_distribution_domain_name
}
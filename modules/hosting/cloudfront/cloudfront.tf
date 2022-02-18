variable "S3_BUCKET" {}

module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = ["*.traveloffice.shop"]

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
    acm_certificate_arn = "arn:aws:acm:us-east-1:249593777629:certificate/20027980-d231-448a-930d-b37a515342dd"
    ssl_support_method  = "sni-only"
  }
}
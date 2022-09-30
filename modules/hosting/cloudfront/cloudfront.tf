variable "S3_BUCKET" {}
variable "ACM" {}
variable "ALIASES" {}
variable "DEFAULT_ROOT_OBJECT" {
  default = "index.html"
}
variable "TAGS" {}
variable "CUSTOM_HEADER_ID" {
  default = null
}
variable "S3_ORIGIN" {
  default = "s3_ogirin"
}

resource "aws_cloudfront_origin_access_control" "s3_access_control" {
  name                              = var.S3_BUCKET.id
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = var.S3_BUCKET.domain
    origin_id                = var.S3_ORIGIN
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_access_control.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = var.ALIASES

  default_cache_behavior {
    allowed_methods            = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods             = ["GET", "HEAD"]
    target_origin_id           = var.S3_ORIGIN
    response_headers_policy_id = var.CUSTOM_HEADER_ID

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = var.TAGS

  viewer_certificate {
    acm_certificate_arn = var.ACM
    ssl_support_method  = "sni-only"
  }

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }
}

output "domain" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
output "arn" {
  value = aws_cloudfront_distribution.s3_distribution.arn
}

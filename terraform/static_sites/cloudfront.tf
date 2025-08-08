resource "aws_cloudfront_origin_access_control" "main" {
  name                              = "${var.namespace}-${var.project_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "main" {
  aliases = var.domain_aliases
  comment             = "${var.namespace}-${var.project_name}"
  default_root_object = var.default_root_object
  enabled             = true
  http_version        = "http2and3"
  is_ipv6_enabled     = true
  price_class = "PriceClass_All"

  origin_group {
    origin_id = "s3_group"

    failover_criteria {
      status_codes = [500, 502, 503, 504]
    }

    member {
      origin_id = "primary_region"
    }

    member {
      origin_id = "dr_region"
    }
  }

  origin {
    domain_name              = aws_s3_bucket.main.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
    origin_id                = "primary_region"
  }

  origin {
    domain_name              = aws_s3_bucket.dr_region.bucket_regional_domain_name
    origin_id                = "dr_region"
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
  }

  logging_config {
    include_cookies = false
    bucket          = var.s3_bucket_logs
    prefix          = "cloudfront/logs/${var.namespace}/${var.project_name}"
  }

  default_cache_behavior {
    allowed_methods           = ["GET", "HEAD", "OPTIONS"]
    cached_methods            = ["GET", "HEAD", "OPTIONS"]
    target_origin_id          = "s3_group"
    cache_policy_id           = var.cache_policy_id
    origin_request_policy_id  = var.origin_request_policy_id
    response_headers_policy_id= var.response_headers_policy_id
    viewer_protocol_policy    = "redirect-to-https"
    compress                  = true

    dynamic "lambda_function_association" {
      for_each = var.lambda_edge
      content {
        event_type   = lambda_function_association.value.event_type
        lambda_arn   = lambda_function_association.value.lambda_arn
        include_body = false
      }
    }
  }

  custom_error_response {
    error_caching_min_ttl = 10
    error_code          = 404
    response_code       = 200
    response_page_path  = "/${var.default_root_object}"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn       = var.create_ssl_certificate ? aws_acm_certificate.us_east_1_ssl_certs[0].arn : var.certificate_arn
    minimum_protocol_version  = "TLSv1.2_2021"
    ssl_support_method        = "sni-only"
  }
}
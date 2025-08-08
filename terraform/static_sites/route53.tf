resource "aws_route53_record" "cloudfront_domain" {
  for_each = toset(var.domain_aliases)

  zone_id = var.route_53_id
  name    = each.value
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "us_east_1_cert_validation" {
  for_each = contains(keys(aws_acm_certificate.us_east_1_ssl_certs), "main") ? {
    for dvo in aws_acm_certificate.us_east_1_ssl_certs["main"].domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
  zone_id = var.route_53_id
}
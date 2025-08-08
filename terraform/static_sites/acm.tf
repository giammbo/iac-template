resource "aws_acm_certificate" "us_east_1_ssl_certs" {
  provider  = aws.us-east-1
  for_each  = var.create_ssl_certificate ? { main = var.domain_aliases } : {}

  domain_name               = each.value[0]
  subject_alternative_names = slice(each.value, 1, length(each.value))
  validation_method         = "DNS"

  lifecycle { create_before_destroy = true }
}
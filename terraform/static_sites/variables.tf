variable "project_name" {
  type = string
  nullable = false
}

variable "namespace" {
  type = string
  nullable = false
}

variable "certificate_arn" {
  type = string
  nullable = true
}

variable "create_ssl_certificate" {
  type = bool
  default = true
  nullable = true
}

variable "s3_bucket_logs" {
  type = string
  nullable = false
}

variable "domain_aliases" {
  type = list(string)
  nullable = false
}

variable "lambda_edge" {
  type = list(object({
    lambda_arn    = string
    event_type    = string
  }))
  default = []
  nullable = true
}

variable "route_53_id" {
  type = string
  nullable = false
}

variable "response_headers_policy_id" {
  type = string
  default = "eaab4381-ed33-4a86-88ca-d9558dc6cd63"
  nullable = true
}

variable "origin_request_policy_id" {
  type = string
  default = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
  nullable = true
}

variable "cache_policy_id" {
  type = string
  default = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  nullable = true
}

variable "default_root_object" {
  type = string
  default = "index.html"
  nullable = true
}
locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
  cloudfront_prefix_list_map = {
    "eu-west-1"    = "pl-4fa04526"
  }
}

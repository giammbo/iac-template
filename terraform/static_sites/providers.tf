provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  alias  = "dr_region"
  region = "eu-central-1"
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

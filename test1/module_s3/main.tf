provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

resource "random_string" "ramdom" {
  length = 6
  upper = false
  special = false
}

resource "aws_s3_bucket" "this" {
  count = var.static_web_S3 ? 1 : 0
  bucket = "tfgenerate-${data.aws_caller_identity.current.account_id}-${random_string.ramdom.result}"

  tags = {
    Name  = "My S3 generate by terraform" 
  }
}

resource "aws_s3_bucket_website_configuration" "this" {
  count = var.static_web_S3 ? 1 : 0
  bucket = "tfgeneratewebsite-${data.aws_caller_identity.current.account_id}-${random_string.ramdom.result}"

  index_document {
    suffix = var.index_static_web_S3
  }

}
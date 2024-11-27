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
  bucket = "tfgenerate-${data.aws_caller_identity.current.account_id}-${random_string.ramdom.result}"

  tags = {
    Name  = "My S3 generate by terraform" 
  }
}

resource "aws_s3_bucket_website_configuration" "this" {
  count = var.static_web_S3 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_account_public_access_block" "public_acces_block" {
  count = var.index_static_web_S3 ? 1 : 0
  block_public_acls = true
  block_public_policy = true
  
}
provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

resource "random_string" "random" {
  length = 6
  upper = false
  special = false
}

resource "aws_s3_bucket" "this" {
  bucket = "tfgenerate-${data.aws_caller_identity.current.account_id}-${random_string.random.result}"

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
  account_id = data.aws_caller_identity.current.account_id
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
  }

resource "aws_s3_object" "upload_object" {
  for_each = fileset("web_source/","*")
  bucket = aws_s3_bucket.this.id
  key = each.value
  source = "web_source/${each.value}"
  content_type = "text/html"
}

resource "aws_s3_bucket_policy" "allow_from_everyone" {
  depends_on = [ aws_s3_account_public_access_block.public_acces_block ]
  bucket = aws_s3_bucket.this.id
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:GetObject",
          ]
          Effect = "Allow"
          Resource = "${aws_s3_bucket.this.arn}/*"
          Principal = "*"
        }
      ]
    }
  )
}
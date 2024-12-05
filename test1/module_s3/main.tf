provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

#Genere un chaine aléatoire pour le nom du bucket
resource "random_string" "random" {
  length = 6
  upper = false
  special = false
}

#Crée un bucket S3
resource "aws_s3_bucket" "this" {
  bucket = "tfgenerate-${data.aws_caller_identity.current.account_id}-${random_string.random.result}"

  tags = {
    Name  = "My S3 generate by terraform" 
  }
}

#Ajout des objet dans le s3
resource "aws_s3_object" "upload_object" {
  for_each = fileset("${var.objet_to_upload}/","*")
  bucket = aws_s3_bucket.this.id
  key = each.value
  source = "${var.objet_to_upload}/${each.value}"
  content_type = "text/html"
}


#Configure le bucket S3 en site web
# resource "aws_s3_bucket_website_configuration" "this" {
#   count = var.static_web_S3 ? 1 : 0
#   bucket = aws_s3_bucket.this.id

#   index_document {
#     suffix = "index.html"
#   }

#   error_document {
#     key = "error.html"
#   }
# }


#Impossible de associer ce block pour le moment
# resource "aws_s3_account_public_access_block" "public_acces_block" {
#   account_id = data.aws_caller_identity.current.account_id
#   block_public_acls = false
#   block_public_policy = false
#   ignore_public_acls = false
#   restrict_public_buckets = false
#   }


#Impossible de mettre en place un S3 visible en public car blocage de mise en public du S3 
# resource "aws_s3_bucket_policy" "allow_from_everyone" {
#   depends_on = [ aws_s3_account_public_access_block.public_acces_block ]
#   bucket = aws_s3_bucket.this.id
#   policy = jsonencode(
#     {
#       Version = "2012-10-17"
#       Statement = [
#         {
#           Action = [
#             "s3:GetObject",
#           ]
#           Effect = "Allow"
#           Resource = "${aws_s3_bucket.this.arn}/*"
#           Principal = "*"
#         }
#       ]
#     }
#   )
# }
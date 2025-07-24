#Crée un bucket S3
resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name
  tags = local.tags
}

#Ajout des objet dans le s3
resource "aws_s3_object" "upload_object" {
  for_each = fileset("${var.objet_to_upload}/","*")
  bucket = aws_s3_bucket.this.id
  key = each.value
  source = "${var.objet_to_upload}/${each.value}"
  content_type = "text/html"
}


# Mise ne place d'une clef KMS pour le chiffrement



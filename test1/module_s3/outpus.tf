#id du bucket S3 générer via le module
output "bucket_id" {
  value = aws_s3_bucket.this.id
}
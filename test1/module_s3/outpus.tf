#Génére un bucket S3 et en fonctions des variable d'entrée le met en public ou en privé
#Peut aussi générer un S3 pour supportter un site en statique


output "addrese_DNS_web_static_S3" {
  value = aws_s3_bucket_website_configuration.this.website_endpoint
}
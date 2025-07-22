locals {
  aws_region   = var.region
  bucket_name  = "tfgenerate-${data.aws_caller_identity.current.account_id}-${random_string.random.result}"

  tags = {
    "training"    = "terraform"
    "aws-account" = "${data.aws_caller_identity.current.account_id}"
    "environment" = "${var.environment}"
  }
}

#Genere un chaine aléatoire pour le nom du bucket
resource "random_string" "random" {
  length = 6
  upper = false
  special = false
}
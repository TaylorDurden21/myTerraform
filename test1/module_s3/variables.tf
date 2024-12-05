variable "region" {
  type = string
  default = "us-east-1"
}

variable "static_web_S3" {    
  description = "Deploie un bucket S3"  
  type = bool
  default = false
}


#Lien d'un dossier qui va être parcouru et ajouter au bucket S3
variable "objet_to_upload" {
  description = "link for the index"
  type = string
}
variable "region" {
  type = string
  default = "us-east-1"
}

variable "static_web_S3" {    
  description = "Deploie un bucket S3"  
  type = bool
  default = false
}

variable "index_static_web_S3" {
  description = "link for the index"
  type = string
}
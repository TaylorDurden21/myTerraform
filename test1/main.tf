provider "aws" {
  region = var.region
}

data "aws_ssm_parameter" "this" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

module "vpc" {
  source = "./module_vpc"
  region = var.region
}

module "S3" {
  source = "./module_s3"
  region = var.region
  static_web_S3 = true
  objet_to_upload = "./web_source"
}

#Création d'un role pour l'EC2 pour prendre objet dans S3
resource "aws_iam_role" "ec2_role" {
  name = "ec2_s3_acess_role"
  #Creation de l'assumer policy du role
  assume_role_policy = jsonencode({
    Version : "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

}

#Attache une policie AWS au role ec2_S3_access_role
resource "aws_iam_role_policy_attachment" "ec2_s3_access_attachement" {
  role = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

#Création d'un instance profile pour permettre d'être rattacher à l'EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

#Obtenir une liste des key sur un bucket S3
data "aws_s3_objects" "web_folder" {
  bucket = module.S3.bucket_name
}

locals {
  #Tranforme une liste en map
  string_map = {for item in data.aws_s3_objects.web_folder.keys : item => item}
}

#Retourne les information de l'objet avec le nom index.html
data "aws_s3_object" "web_index"{
  bucket = module.S3.bucket_name
  key =lookup(
    local.string_map,
    "index.html",
    "not found"
  )
}

resource "aws_instance" "my-instance" {
  ami = data.aws_ssm_parameter.this.value
  associate_public_ip_address = true
  subnet_id = module.vpc.subnet_id
  vpc_security_group_ids = [module.vpc.security_group_id]
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name


  #utilisé les fonctions (perform dynamic operation) sur terraform pour mieux définir les user dats
  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install -y httpd
  sudo systemctl start httpd
  sudo systemctl enable httpd
  aws s3 cp s3://${data.aws_s3_object.web_index.id} /home/ec2-user/
  sudo mv /home/ec2-user/index.html /var/www/html/
  EOF
#Associer le droit sur le ec2 pour qu'il puissé télécharger sur le S3 
#Télécharger le fichier sur le S3 
# Le déplacer au bonne endroit sur le serveur web
  tags = {
    Name  = "My_EC2_generate_by_terraform" 
  }
}
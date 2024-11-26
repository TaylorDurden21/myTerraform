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
  index_static_web_S3 ="./web_source/index.html"
}

resource "aws_instance" "my-instance" {
  ami = data.aws_ssm_parameter.this.value
  associate_public_ip_address = true
  subnet_id = module.vpc.subnet_id
  vpc_security_group_ids = [module.vpc.security_group_id]
  instance_type = "t2.micro"
}
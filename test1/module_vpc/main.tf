provider "aws" {
    region = var.region
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "this" {
  vpc_id = aws_vpc.this.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  #Route lcoale pour le VPC / Subnet
  route {
    cidr_block = aws_vpc.this.cidr_block
    gateway_id = "local"
  }

  # Route par défaut vers internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    name = "MainRouteTable"
  }
}

resource "aws_route_table_association" "this" {
    subnet_id = aws_subnet.this.id
    route_table_id = aws_route_table.this.id
}

resource "aws_security_group" "this" {
  name = "allow_ssh_http_internet"
  description = "Allow SSH and Http ingress and internet all egress"
  vpc_id = aws_vpc.this.id
  
  tags = {
    name = "allow_ssh_http_internet_all"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ingress" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4 = aws_vpc.this.cidr_block
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ingress" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4 = aws_vpc.this.cidr_block
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_engress" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

# VPC - Subnet - Internet Gateway - Route Table - Route table association - SG (allow http & SSH) 
# S3 Module 
#alb module
# Secret Manager module 
#Module AMI
#Générer une AMI puis la déployer via un template sur un EC2 
output "ec2_ID" {
  value = aws_instance.my-instance.id
}

output "addrese_DNS_web_static_S3" {
  value = module.S3.addrese_DNS_web_static_S3.value
}
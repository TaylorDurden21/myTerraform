output "ec2_ID" {
  value = aws_instance.my-instance.id
}

output "s3_index_object_uri" {
  value = data.aws_s3_object.web_index
}

output "testPrint" {
  value = data.aws_s3_objects.web_folder
}
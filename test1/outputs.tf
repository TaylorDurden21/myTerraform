output "ec2_ID" {
  description = "Id de ec2"
  value = join(":", ["ID de mon ec2 est :", tostring(aws_instance.my-instance.id)]) 
}

output "s3_index_object_uri" {
  description = "ID de objet"
  value = data.aws_s3_object.web_index.id
}

output "testPrint" {
  value = data.aws_s3_objects.web_folder
}


# output "url" {
#   description = "Browser URL for container site"
#   value       = join(":", ["http://localhost", tostring(var.external_port)])
# }
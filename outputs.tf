# output "elb_dns_name" {
#   value = aws_elb.matheus-test-elb.dns_name
# }

# # output "s3_bucket_name" {
# #   value = aws_s3_bucket.mybucket.id
# # }

# # output "aws_cloudfront_distribution_domain_name" {
# #   value = aws_cloudfront_distribution.test-cloudfront.domain_name
# # }

# output "instance_id" {
#   value       = [aws_instance.ec2-docker.public_ip, aws_instance.ec2-k8s.public_ip, aws_instance.ec2-backend[*].public_ip]
#   description = "ID da instância EC2 criada"
# }

# output "public_ip" {
#   value       = [aws_instance.ec2-docker.public_ip, aws_instance.ec2-k8s.public_ip, aws_instance.ec2-backend[*].public_ip]
#   description = "Endereço IP público da instância EC2"
# }

# output "private_ip" {
#   value       = [aws_instance.ec2-docker.public_ip, aws_instance.ec2-k8s.public_ip, aws_instance.ec2-backend[*].public_ip]
#   description = "Endereço IP privado da instância EC2"
# }
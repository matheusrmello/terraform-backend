output "ec2_public_ips" {
  value = [aws_instance.ec2-docker.public_ip, aws_instance.ec2-k8s.public_ip, aws_instance.ec2-backend[*].public_ip]
}

output "elb_dns_name" {
  value = aws_elb.matheus-test-elb.dns_name
}

# output "s3_bucket_name" {
#   value = aws_s3_bucket.mybucket.id
# }

# output "aws_cloudfront_distribution_domain_name" {
#   value = aws_cloudfront_distribution.test-cloudfront.domain_name
# }
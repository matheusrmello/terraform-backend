
# locals {
#   s3_bucket_name = "matheus-cloudfront-test"
#   domain         = "exam.ezopscloud.tech"
#   hosted_zone_id = "Z08622851AKBHFB3GT1EP"
#   cert_arn       = ""
# }

# data "aws_iam_policy_document" "cloudfront_oac_access" {
#   statement {
#     principals {
#       identifiers = ["cloudfront.amazonaws.com"]
#       type        = "Service"
#     }
#     actions   = ["s3:GetObject"]
#     resources = ["${aws_s3_bucket.mybucket.arn}/*"]

#     condition {
#       test     = "StringEquals"
#       values   = [aws_cloudfront_distribution.test-cloudfront.arn]
#       variable = "AWS:SourceArn"
#     }
#   }
# }


# #### S3
# resource "aws_s3_bucket" "mybucket" {
#   bucket        = local.s3_bucket_name
#   force_destroy = true
#   tags = {
#     Name = "test-matheus-bucket-s3"
#   }
# }

# resource "aws_s3_bucket_policy" "s3_policy" {
#   bucket = aws_s3_bucket.mybucket.id
#   policy = data.aws_iam_policy_document.cloudfront_oac_access.json
# }


# #### CloudFront
# resource "aws_cloudfront_distribution" "test-cloudfront" {
#   comment             = "CloudFront Distribution for Vue.js app managed by Terraform"
#   enabled             = true
#   default_root_object = "index.html"
#   is_ipv6_enabled     = true
#   wait_for_deployment = true

#   default_cache_behavior {
#     allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
#     cached_methods         = ["GET", "HEAD"]
#     cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
#     target_origin_id       = aws_s3_bucket.mybucket.bucket
#     viewer_protocol_policy = "redirect-to-https"
#     min_ttl                = 0
#     default_ttl            = 3600
#     max_ttl                = 86400

#   }

#   origin {
#     domain_name              = aws_s3_bucket.mybucket.bucket_domain_name
#     origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_access_controll.id
#     origin_id                = aws_s3_bucket.mybucket.id
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }



#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }

#   tags = {
#     Name = "test-matheus-cloudfront"
#   }
# }

# resource "aws_cloudfront_origin_access_control" "cloudfront_access_controll" {
#   name                              = "s3_cloudfront-oac-test"
#   origin_access_control_origin_type = "s3"
#   signing_behavior                  = "always"
#   signing_protocol                  = "sigv4"
# }

# #### Route 53
# resource "aws_route53_record" "route53_record" {
#   name    = local.domain
#   type    = "A"
#   zone_id = local.hosted_zone_id

#   alias {
#     evaluate_target_health = false
#     name                   = aws_cloudfront_distribution.test-cloudfront.domain_name
#     zone_id                = aws_cloudfront_distribution.test-cloudfront.hosted_zone_id
#   }
# }


# #### ACM
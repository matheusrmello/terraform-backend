
locals {
  s3_bucket_name = "matheus-cloudfront-test"
  domain         = "test-matheus.ezopscloud.tech"
  hosted_zone_id = "Z08622851AKBHFB3GT1EP"
}

# data "aws_iam_policy_document" "cloudfront_oac_access" {
#   statement {
#     principals {
#       identifiers = ["cloudfront.amazonaws.com"]
#       type        = "Service"
#     }
#     actions   = ["s3:GetObject"]
#     resources = ["${aws_s3_bucket.frontend_bucket.arn}/*"]

#     condition {
#       test     = "StringEquals"
#       values   = [aws_cloudfront_distribution.test-cloudfront.arn]
#       variable = "AWS:SourceArn"
#     }
#   }
# }
# data "aws_iam_policy_document" "s3_bucket_policy" {
#   statement {
#     actions   = ["s3:GetObject"]
#     resources = ["${aws_s3_bucket.frontend_bucket.arn}/*"]
#     principals {
#       type        = "Service"
#       identifiers = ["cloudfront.amazonaws.com"]
#     }
#     condition {
#       test     = "StringEquals"
#       variable = "AWS:SourceArn"
#       values   = [aws_cloudfront_distribution.test-cloudfront.arn]
#     }
#   }
# }



#### S3
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = local.s3_bucket_name
  tags = {
    Name = "test-matheus-bucket-s3"
  }
}

resource "aws_s3_bucket_public_access_block" "static_site_bucket_public_access" {
  bucket = aws_s3_bucket.frontend_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "static_site_bucket_website_config" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "provision_source_files" {
  bucket = aws_s3_bucket.frontend_bucket.id

  for_each = fileset("cloudfront/dist/", "**/*.*")

  key          = each.value
  source       = "cloudfront/dist/${each.value}"
  content_type = each.value
}

resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id
  policy = aws_s3_bucket_policy.this.policy
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.frontend_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "AllowCloudFrontAccess"
    Statement = [
      {
        Sid    = "AllowCloudFront"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.frontend_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.test-cloudfront.arn
          }
        }
      }
    ]
  })
}
#### CloudFront
resource "aws_cloudfront_distribution" "test-cloudfront" {
  comment             = "CloudFront Distribution for Vue.js app managed by Terraform"
  enabled             = true
  default_root_object = "index.html"
  is_ipv6_enabled     = true
  wait_for_deployment = true

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    target_origin_id       = "my-s3-origin"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

  }

  origin {
    domain_name              = aws_s3_bucket.frontend_bucket.bucket_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_access_controll.id
    origin_id                = "my-s3-origin"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    Name = "test-matheus-cloudfront"
  }
}

resource "aws_cloudfront_origin_access_control" "cloudfront_access_controll" {
  name                              = "s3_cloudfront-oac-test"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

#### Route 53


resource "aws_route53_record" "cert_validation" {
    for_each = {
        for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
                name    = dvo.resource_record_name
                type    = dvo.resource_record_type
                records = [dvo.resource_record_value]
            }
        }
    

   allow_overwrite = true
    zone_id         = data.aws_route53_zone.selected.zone_id
    type            = each.value.type
    name            = each.value.Name
    records         = each.value.records
    ttl             = 60
}

# resource "aws_route53_record" "www" {
#   zone_id = data.aws_route53_zone.selected.zone_id
#   name = "www.${local.domain}"
#   type = "A"
# }

#### ACM

resource "aws_acm_certificate" "cert" {
  domain_name               = local.domain
  validation_method         = "DNS"
  subject_alternative_names = ["*.${local.domain}"]
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "test-matheus-acm"
  }

}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]

}
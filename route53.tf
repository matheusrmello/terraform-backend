data "aws_acm_certificate" "amazon_issued_api" {
  provider    = aws.us_east_1
  domain      = "mrmello.com.br"
  types       = ["AMAZON_ISSUED"]
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "zone_api" {
  name         = "mrmello.com.br."
  private_zone = false
}

resource "aws_route53_record" "alias_route53_record_api" {
  zone_id = data.aws_route53_zone.zone_api.zone_id
  name    = "api-test-matheus"
  type    = "CNAME"
  ttl     = 300
  records = [aws_alb.application_load_balancer.dns_name]
}
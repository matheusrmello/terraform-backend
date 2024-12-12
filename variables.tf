variable "key_pair_name" {
  description = "Key_pair_name"
  type        = string
}

variable "instance_type" {
  description = "instance_type"
  type        = string
}

variable "ami" {
  description = "AMI"
  type        = string
}

variable "instance_tag" {
  description = "instance_tag"
  type        = string
}

variable "file_type" {
  description = "Name of the key pair"
  type        = string
}

variable "cidr_block" {
  description = "CIDR Block"
  type        = string
}

variable "availability_zone" {
  description = "Availability Zones for the subnet"
  type        = list(string)
}

variable "region" {
  description = "Region"
  type        = string
}

variable "private_subnets" {
  description = "Private subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
}

variable "s3_bucket" {
  description = "Bucket S3"
  type        = string
}

variable "cdn_domain" {
  description = "Domain CDN"
  type        = string
}

variable "route53_zone_domain" {
  description = "Domain zone of Route53"
}
variable "cloudfront_allowed_methods" {
  default = ["GET", "HEAD", "OPTIONS"]
  type    = list(string)
}

variable "cloudfront_cached_methods" {
  default = ["GET", "HEAD", "OPTIONS"]
  type    = list(string)
}

variable "cloudfront_default_root_object" {
  default = "index.html"
  type    = string
}

variable "cloudfront_http_version" {
  default = "http2"
  type    = string
}

variable "service" {
  default     = "test-matheus-terraform-cdn"
  type        = string
  description = "Service name"
}

variable "stage" {
  default     = "dev"
  type        = string
  description = "Stage (dev, test, prod)"
}

variable "route53_private_zone" {
  default = false
  type    = bool
}

variable "default_tags" {
  description = "Default tags for the resources"
  type        = string
}
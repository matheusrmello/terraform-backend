variable "region" {
  description = "Region"
  default     = "us-east-2"
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
  type        = string
  description = "Service name"
}

variable "route53_private_zone" {
  default = false
  type    = bool
}
################# EC2 #########################

variable "key_pair_name" {
  description = "Key_pair_name"
  type        = string
}

variable "instance_type" {
  description = "instance_type"
  type        = string
  default     = "t3.medium"
}

variable "ami_id" {
  type        = string
  description = "AMI ID para a instância EC2"
  default     = "ami-0c80e2b6ccb9ad6d1"
}

variable "associate_public_ip" {
  type        = bool
  description = "Se deve associar um IP público à instância"
  default     = true
}



################# ECS #########################


variable "default_tags" {
  description = "Default tags for the resources"
  default     = "test-matheus"
}

variable "cluster_name" {
  description = "The name of the ECS cluster"
  default     = "test_matheus_ecs_cluster"
}

variable "container_name" {
  description = "The name of the task definition"
  default     = "test_task_backend_api"
}

variable "ecr_repo_url" {
  description = "The ECR repository URL for the container image"
  type        = string
}

variable "container_port" {
  description = "The container port to expose"
  default     = 8080
}

variable "host_port" {
  description = "The host port to map to the container port"
  default     = 8080
}

variable "desired_count" {
  description = "number os desired tasks"
  default     = 2
}

################# VPC #########################

variable "cidr_block" {
  description = "CIDR Block"
  default     = "10.0.0.0/16"
}

variable "availability_zone" {
  description = "Availability Zones for the subnet"
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "private_subnets" {
  description = "Private subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "Public subnets"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

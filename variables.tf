variable "region" {
  description = "Region"
  default     = "us-east-2"
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

variable "availability_zone" {
  description = "Availability Zones for the subnet"
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}
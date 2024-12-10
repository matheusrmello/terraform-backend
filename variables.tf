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
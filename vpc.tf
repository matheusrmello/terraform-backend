module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "matheus-test-vpn"
  cidr = var.cidr_block

  azs             = var.availability_zone
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway      = false
  enable_dns_hostnames    = true
  map_public_ip_on_launch = true
  create_igw              = true

  tags = {
    Terraform = "true"
    Name      = "matheus-test-vpc"
  }
}

resource "aws_db_instance" "postgres_db" {
  allocated_storage    = 10
  db_name              = "blog"
  engine               = "postgres"
  engine_version       = "14"
  instance_class       = "db.t3.micro"
  username             = "root"
  password             = "928BDeuE"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db_subnet.id
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet"
  subnet_ids = [module.vpc.public_subnets[0], module.vpc.public_subnets[1], module.vpc.public_subnets[2], ]
}

# resource "aws_subnet" "public_subnets_db_1" {
#   vpc_id = module.vpc.id
#   cidr_block = "10.0.103.0/24"
#   availability_zone = "us-east-2a"
# }

# resource "aws_subnet" "public_subnets_db_2" {
#   vpc_id = module.vpc.id
#   cidr_block = "10.0.104.0/24"
#   availability_zone = "us-east-2b"
# }
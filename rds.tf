resource "aws_db_instance" "postgres_db" {
  identifier             = "rds-postgres"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "11"
  instance_class         = "db.t3.micro"
  db_name                = "blog"
  username               = "root"
  password               = "928BDeuE"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.id

  tags = {
    Name = "test-matheus-rds"
  }
}

# resource "null_resource" "init_db" {
#   depends_on = [aws_db_instance.postgres_db]

#   provisioner "local-exec" {
#     command = <<EOT
#       set PGPASSWORD=${aws_db_instance.postgres_db.password}
#       psql -h ${aws_db_instance.postgres_db.address} -U ${aws_db_instance.postgres_db.username} -d ${aws_db_instance.postgres_db.db_name} -c "CREATE SCHEMA blog;"
#       psql -h ${aws_db_instance.postgres_db.address} -U ${aws_db_instance.postgres_db.username} -d ${aws_db_instance.postgres_db.db_name} -c "CREATE TABLE blog.post (id serial PRIMARY KEY, title text NOT NULL, content text NOT NULL, date timestamp DEFAULT now());"
#     EOT
#   }
# }

resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet"
  subnet_ids = [aws_subnet.rds_subnet_1.id, aws_subnet.rds_subnet_2.id]

  tags = {
    Name = "test-rds-subnet-group"
  }
}
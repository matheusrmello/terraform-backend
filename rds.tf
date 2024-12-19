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

resource "null_resource" "create_table" {
  provisioner "remote-exec" {
    inline = [
      "set PGPASSWORD=928BDeuE",
      "psql -h ${aws_db_instance.postgres_db.address} -U root -d blog -c \"CREATE SCHEMA IF NOT EXISTS blog;\"",
      "psql -h ${aws_db_instance.postgres_db.address} -U root -d blog -c \"CREATE TABLE IF NOT EXISTS blog.post (id SERIAL PRIMARY KEY, title TEXT NOT NULL, content TEXT NOT NULL, date TIMESTAMP DEFAULT NOW());\""
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./matheus-kp.pem")
      host        = self.public_ip
    }
  }
  depends_on = [aws_db_instance.postgres_db]
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet"
  subnet_ids = [aws_subnet.rds_subnet_1.id, aws_subnet.rds_subnet_2.id]

  tags = {
    Name = "test-rds-subnet-group"
  }
}
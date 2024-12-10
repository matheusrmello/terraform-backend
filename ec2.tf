resource "aws_instance" "ec2-backend" {
  count                  = 2
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = var.key_pair_name
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Name = "matheus-test-backend ${count.index + 1}"
  }

}

resource "aws_instance" "ec2-docker" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = var.key_pair_name
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Name = "matheus-test-docker"
  }

}

resource "aws_instance" "ec2-k8s" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = var.key_pair_name
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Name = "matheus-test-k8s"
  }

}

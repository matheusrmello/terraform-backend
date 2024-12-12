data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "ec2-backend" {
  count                  = 2
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg_docker.id]
  key_name               = var.key_pair_name
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Name = "matheus-test-backend ${count.index + 1}"
  }

}

resource "aws_instance" "ec2-docker" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg_docker.id]
  key_name               = var.key_pair_name
  subnet_id              = module.vpc.public_subnets[0]
  monitoring             = true
  user_data              = file("${path.module}/scripts/install-docker.sh")

  tags = {
    Name = "matheus-test-docker"
  }

}

resource "aws_instance" "ec2-k8s" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg_k8s.id]
  key_name               = var.key_pair_name
  subnet_id              = module.vpc.public_subnets[0]
  user_data              = file("${path.module}/scripts/install-k8s.sh")

  tags = {
    Name = "matheus-test-k8s"
  }

}
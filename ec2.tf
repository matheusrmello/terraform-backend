resource "aws_instance" "instance-backend" {
  count                       = var.backend_instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.sg_k8s.id]
  key_name                    = var.key_pair_name
  subnet_id                   = module.vpc.public_subnets[0]
  monitoring                  = true
  associate_public_ip_address = var.associate_public_ip



  tags = {
    Name = "matheus-test-backend ${count.index + 1}"
  }

}

resource "aws_instance" "instance-docker" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.sg_docker.id]
  key_name                    = var.key_pair_name
  subnet_id                   = module.vpc.public_subnets[0]
  monitoring                  = true
  associate_public_ip_address = var.associate_public_ip
  user_data                   = file("${path.module}/scripts/install-docker.sh")

  tags = {
    Name = "matheus-test-docker"
  }

}

resource "aws_instance" "instance-k8s" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.sg_k8s.id]
  key_name                    = var.key_pair_name
  subnet_id                   = module.vpc.public_subnets[0]
  monitoring                  = true
  associate_public_ip_address = var.associate_public_ip
  user_data                   = file("${path.module}/scripts/install-k8s.sh")

  # user_data = <<-EOF
  #   #!/bin/bash
  #   sudo apt-get update -y
  #   sudo apt-get install -y curl apt-transport-https ca-certificates software-properties-common
  #   sudo apt-get install -y docker.io
  #   sudo systemctl start docker
  #   sudo systemctl enable docker
  #   sudo usermod -aG docker ubuntu
  #   curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
  #   chmod +x ./kind
  #   sudo mv ./kind /usr/local/bin/kind
  #   EOF


  # provisioner "remote-exec" {
  #   inline = [
  #     "kind --version",
  #     "docker --version"
  #   ]

  #   connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     private_key = file("./matheus-kp.pem")
  #     host        = self.public_ip
  #   }
  # }

  tags = {
    Name = "matheus-test-k8s"
  }

}
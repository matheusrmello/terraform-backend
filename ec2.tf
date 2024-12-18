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

  provisioner "remote-exec" {
    inline = [ 
      "sudo yum update -y",
      "sudo yum install -y docker",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo usermod -a -G docker ec2-user",
      "sudo yum install -y git",
      "sudo chkconfig docker on",
      "sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "git clone https://github.com/matheusrmello/compose-ezops.git",
      "cd compose-ezops",
      "sudo docker-compose up -d"
     ]

     connection {
       type = "ssh"
       user = "ec2-user"
       private_key = file("./matheus-kp.pem")
       host = self.public_ip
     }
  }

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
  # user_data                   = file("${path.module}/scripts/install-k8s.sh")

  provisioner "remote-exec" {
    inline = [ 
      "sudo yum update -y",
      "sudo yum install -y docker",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo usermod -a -G docker ec2-user",
      "sudo yum install -y git",
      "sudo chkconfig docker on",
      "curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64",
      "chmod +x minikube",
      "sudo mv minikube /usr/local/bin/",
      "curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl",
      "chmod +x kubectl",
      "sudo mv kubectl /usr/local/bin/",
      "minikube start --driver=docker",
      "minikube status"
     ]

     connection {
       type = "ssh"
       user = "ec2-user"
       private_key = file("./matheus-kp.pem")
       host = self.public_ip
     }
  }

  tags = {
    Name = "matheus-test-k8s"
  }

}
resource "aws_instance" "instance-docker" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg_docker.id]
  key_name               = var.key_pair_name
  subnet_id              = aws_subnet.public_subnet_1.id
  associate_public_ip_address = var.associate_public_ip
  monitoring             = true

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
    tags = {
      Name = "matheus-test-docker-disk"
    }
  }


  provisioner "remote-exec" {
    inline = [
      "sleep 20",
      "sudo yum update -y",
      "sudo yum install -y docker",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo systemctl enable docker.service",
      "sudo usermod -a -G docker ec2-user",
      "sudo yum install -y git",
      "sudo chkconfig docker on",
      "sleep 15",
      "sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sleep 15",
      "git clone https://github.com/matheusrmello/api-compose.git",
      "cd api-compose",
      "sleep 15",
      "sudo docker-compose up -d"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./matheus-kp.pem")
      host        = self.public_ip
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
  subnet_id                   = aws_subnet.public_subnet_1.id
  monitoring                  = true
  associate_public_ip_address = var.associate_public_ip

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
    tags = {
      Name = "matheus-test-k8s-disk"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 20",
      "sudo yum update -y",
      "sudo yum install -y docker",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo usermod -aG docker $USER",
      "sudo yum install -y git",
      "sudo chkconfig docker on",
      "curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64",
      "chmod +x minikube",
      "sudo mv minikube /usr/local/bin/",
      "curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl",
      "chmod +x kubectl",
      "sudo mv kubectl /usr/local/bin/",
      "sleep 10",
      "git clone https://github.com/matheusrmello/api-compose.git",
      "sudo minikube start driver=docker --force",
      "sudo minikube addons enable ingress",
      "sudo minikube addons enable csi-hostpath-driver",
      "sleep 15",
      "cd api-compose/k8s/",
      "sudo kubectl create ns test",
      "sudo kubectl apply -f ./ -n test",
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./matheus-kp.pem")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "matheus-test-k8s"
  }

}

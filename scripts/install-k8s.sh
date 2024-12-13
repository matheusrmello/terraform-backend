#!/bin/bash
# Atualize o sistema
sudo su

yum update -y

# Instale dependências para compilar software e wget
amazon-linux-extras install docker
yum install -y wget curl

sleep 15s

chech_docker_installed() {
  if command -v docker &> /dev/null
  then
    echo "Docker is not installed."
  else
    echo "Docker not found. Installing now..."
    sudo amazon-linux-extras enable docker
    sudo yum install -y docker
    sudo systemctl start docker
    sudo usermod -aG docker && newgrp docker
  fi
}
yum install -y docker
service docker start
usermod -a -G docker ec2-user

sleep 15s

# Instale o kubectl
curl -LO "https://dl.k8s.io/release/v1.25.4/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

sleep 15s

# Instalar o Minikube
LATEST_VERSION=$(curl -s https://api.github.com/repos/kubernetes/minikube/releases/latest | grep "tag_name" | cut -d '"' -f 4)

curl -Lo minikube https://storage.googleapis.com/minikube/releases/${LATEST_VERSION}/minikube-linux-amd64
chmod +x minikube
mv minikube /usr/local/bin/

sleep 15s

check_minikube_started() {
  if minikube profile list | grep -q "minikube"
  then
    echo "Minikube perfil 'minikube' founded."
    if minikube status | grep -q "minikube"
    then
      echo "Minikube is running."
    else
      echo "Minikube is not running. Starting now..."
      minikube start --driver=docker || (echo "Error started Minikube"; exit 1)
    fi
  else
    echo "Minikube profile 'minikube' not founded. Create a new profile and startded Minikube"
    minikube start --driver=docker || (echo "Error started Minikube"; exit 1)
  fi
}

check_minikube_started

minikube status


#!/bin/bash

sudo yum update -y

sudo yum install -y wget curl git docker docker-compose

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is not installed. Installing now..."
  sudo amazon-linux-extras enable docker
  sudo yum install -y docker
  sudo systemctl start docker
  sudo usermod -aG docker $USER && newgrp docker
else
  echo "Docker already installed."
fi

if ! command -v docker-compose >/dev/null 2>&1; then
  echo "Docker Compose is not installed. Installing now..."
  sudo curl -L "https://github.com/docker/compose/releases/download/v2.18.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
else
  echo "Docker Compose already installed."
fi

MINIKUBE_VERSION=$(curl -s https://api.github.com/repos/kubernetes/minikube/releases/latest | grep "tag_name" | cut -d '"' -f 4)
curl -LO "https://dl.k8s.io/release/v${MINIKUBE_VERSION}/bin/linux/amd64/kubectl" -s 
chmod +x kubectl
mv kubectl /usr/local/bin/

MINIKUBE_PATH=/usr/local/bin/minikube
curl -Lo $MINIKUBE_PATH https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION}/minikube-linux-amd64 -s
chmod +x $MINIKUBE_PATH

if ! minikube profile list | grep -q "minikube"; then
  echo "Minikube profile 'minikube' not found. Creating a new profile and starting Minikube..."
  $MINIKUBE_PATH start --driver=docker || (echo "Error starting Minikube"; exit 1)
elif ! minikube status | grep -q "Running"; then
  echo "Minikube is not running. Starting now..."
  $MINIKUBE_PATH start --driver=docker || (echo "Error starting Minikube"; exit 1)
else
  echo "Minikube is already running."
fi

minikube status
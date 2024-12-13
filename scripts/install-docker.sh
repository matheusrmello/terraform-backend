#!/bin/bash

#!/bin/bash
# Atualize o sistema
sudo su

yum update -y

# Instale dependências para compilar software e wget
amazon-linux-extras install docker
yum install -y wget curl

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
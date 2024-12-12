#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "Este script deve ser executado como root." >&2
    exit 1
fi

apt-get update -y
apt-get install ca-certificates curl -y
install -m 0755 -d /etc/apt/keyrings -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y

apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin curl conntrack -y

groupadd docker

sudo usermod -aG docker $USER

newgrp docker

systemctl enable docker

systemctl start docker

docker run hello-world
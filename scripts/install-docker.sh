#!/bin/bash


sudo yum update -y
sudo yum install -y amazon-linux-extras
sudo amazon-linux-extras install docker
sudo systemctl start docker
sudo usermod -a -G docker ec2-user
sudo systemctl enable docker
sudo yum install -y git
sudo chkconfig docker on
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
git clone https://github.com/matheusrmello/api-compose.git
cd api-compose
sudo docker-compose up
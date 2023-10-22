#!/bin/bash

if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."

  # Add Docker's official GPG key:
  apt-get update &>/dev/null
  apt-get install ca-certificates curl gnupg 
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  chmod a+r /etc/apt/keyrings/docker.gpg

  # Add the repository to Apt sources:
  echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null

  # apt-get update
  apt-get install docker.io -y
  useradd -m jenkins
  usermod -aG docker jenkins
  echo "Docker has been installed."

else
    echo "Docker is already installed. No changes were made."
fi

echo 'Docker has been installed'
docker --version

echo 'Launching SonarQube container...'
docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 8080:9000 sonarqube:latest

echo 'Exposing SonarQube outside...'
iptables -t nat -A PREROUTING -p tcp --dport 9000 -j DNAT --to-destination 172.17.0.1:9000

apt-get install iptables-persistent -y
sudo netfilter-persistent save
sudo systemctl enable netfilter-persistent




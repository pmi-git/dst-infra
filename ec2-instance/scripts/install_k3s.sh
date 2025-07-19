#!/bin/bash

set -e

# Installer K3s
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

# Installer Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh

# Installer Docker
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Ajout du dépôt Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installation de Docker
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Ajouter l'utilisateur Jenkins (ou ubuntu si besoin) au groupe docker
sudo usermod -aG docker jenkins 2>/dev/null || true

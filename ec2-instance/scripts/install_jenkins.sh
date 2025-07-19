#!/bin/bash
set -e

echo "🧼 Mise à jour du système..."
sudo apt update -y
sudo apt upgrade -y

echo "☕ Installation de Java (OpenJDK 17)..."
sudo apt install -y fontconfig openjdk-17-jre

echo "🔑 Ajout de la clé Jenkins..."
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "📦 Ajout du dépôt Jenkins..."
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "🔁 Mise à jour des paquets..."
sudo apt update -y

echo "🚀 Installation de Jenkins..."
sudo apt install -y jenkins

echo "🔧 Activation et démarrage de Jenkins..."
sudo systemctl enable --now jenkins
sudo apt install git -y

echo "✅ Jenkins installé et lancé !"

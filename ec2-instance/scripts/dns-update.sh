#!/bin/bash
set -e
cd "$(dirname "$0")/.."

# Charger le .env
[ -f .env ] && source .env

if [[ -z "$DUCKDNS_TOKEN" || -z "$DUCKDNS_DOMAIN" ]]; then
  echo "❌ DUCKDNS_TOKEN ou DUCKDNS_DOMAIN manquant dans .env"
  exit 1
fi

IP=$(terraform output -raw instance_public_ip)
# Obtenir l’ID et l’IP publique de l’instance
INSTANCE_ID=$(terraform output -raw instance_id)
IP=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" \
     --query "Reservations[0].Instances[0].PublicIpAddress" --output text)

# Mise à jour DuckDNS
RESPONSE=$(curl -s "https://www.duckdns.org/update?domains=${DUCKDNS_DOMAIN}&token=${DUCKDNS_TOKEN}&ip=${IP}")

if [[ "$RESPONSE" == "OK" ]]; then
  echo "🌐 DNS mis à jour : ${DUCKDNS_DOMAIN}.duckdns.org → ${IP}"
else
  echo "❌ Erreur lors de la mise à jour DuckDNS : $RESPONSE"
fi

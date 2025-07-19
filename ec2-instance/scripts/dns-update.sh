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

RESPONSE=$(curl -s "https://www.duckdns.org/update?domains=${DUCKDNS_DOMAIN}&token=${DUCKDNS_TOKEN}&ip=${IP}")

if [[ "$RESPONSE" == "OK" ]]; then
  echo "🌐 DNS mis à jour : ${DUCKDNS_DOMAIN}.duckdns.org → ${IP}"
else
  echo "❌ Erreur lors de la mise à jour DuckDNS : $RESPONSE"
fi

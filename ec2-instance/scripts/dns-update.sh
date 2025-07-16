#!/bin/bash
source .env

cd "$(dirname "$0")/.."

# Récupération de l’IP publique de l’instance
IP=$(terraform output -raw instance_public_ip)

# Infos Cloudns
DOMAIN="pmi.ip-ddns.com"
RECORD="ec2"
FULL_NAME="${RECORD}.${DOMAIN}"

# Mise à jour via l'API
curl -s "https://api.cloudns.net/dns/update-record.json" \
  -d "auth-id=${CLOUDNS_AUTH_ID}" \
  -d "auth-password=${CLOUDNS_AUTH_PASS}" \
  -d "domain-name=${DOMAIN}" \
  -d "record-name=${RECORD}" \
  -d "record-type=A" \
  -d "record-data=${IP}" \
  -d "ttl=300"

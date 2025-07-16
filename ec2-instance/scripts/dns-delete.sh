#!/bin/bash
cd "$(dirname "$0")/.."

if [ ! -f .env ]; then
  echo "❌ Fichier .env manquant. Impossible de continuer."
  exit 1
fi

source .env

# Vérif des variables
if [[ -z "$CLOUDNS_AUTH_ID" || -z "$CLOUDNS_AUTH_PASS" || -z "$DOMAIN" || -z "$RECORD" ]]; then
  echo "❌ Variables manquantes. Vérifie ton .env (CLOUDNS_AUTH_ID, CLOUDNS_AUTH_PASS, DOMAIN, RECORD)."
  exit 1
fi

# Requête à l'API ClouDNS pour lister les enregistrements
RECORDS=$(curl -s "https://api.cloudns.net/dns/get-records.json" \
  -d "auth-id=$CLOUDNS_AUTH_ID" \
  -d "auth-password=$CLOUDNS_AUTH_PASS" \
  -d "domain-name=$DOMAIN" \
  -d "record-type=A")

# Extraire l'ID du record avec jq (filtre par nom)
RECORD_ID=$(echo "$RECORDS" | jq -r \
  --arg name "$RECORD" '
    to_entries[] | select(.value.host == $name) | .key
  ')

if [[ -z "$RECORD_ID" ]]; then
  echo "⚠️ Aucun enregistrement A nommé '$RECORD' trouvé dans $DOMAIN"
  exit 0
fi

# Suppression via l’API
curl -s "https://api.cloudns.net/dns/delete-record.json" \
  -d "auth-id=$CLOUDNS_AUTH_ID" \
  -d "auth-password=$CLOUDNS_AUTH_PASS" \
  -d "domain-name=$DOMAIN" \
  -d "record-id=$RECORD_ID"

echo "🧹 Record DNS supprimé : ${RECORD}.${DOMAIN} (ID: $RECORD_ID)"

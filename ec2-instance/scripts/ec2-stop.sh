#!/bin/bash
cd "$(dirname "$0")/.."

INSTANCE_ID=$(terraform show -json | jq -r '.values.root_module.resources[] | select(.type=="aws_instance") | .values.id')

if [ -z "$INSTANCE_ID" ]; then
  echo "❌ Impossible de trouver l'instance."
  exit 1
fi

REGION=$(terraform output -raw aws_region)

aws ec2 stop-instances --instance-ids "$INSTANCE_ID" --region "$REGION"
echo "🛑 Instance EC2 arrêtée : $INSTANCE_ID"

# Suppression DNS
./scripts/dns-delete.sh

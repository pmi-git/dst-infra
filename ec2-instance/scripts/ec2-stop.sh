#!/bin/bash
cd "$(dirname "$0")/.."

INSTANCE_ID=$(terraform show -json | jq -r '.values.root_module.resources[] | select(.type=="aws_instance") | .values.id')

if [ -z "$INSTANCE_ID" ]; then
  echo "❌ Impossible de trouver l'instance."
  exit 1
fi

REGION=$(terraform output -raw aws_region 2>/dev/null)

if [[ -z "$REGION" ]]; then
  echo "❌ aws_region introuvable. As-tu bien fait un 'terraform apply' après l'avoir défini ?"
  exit 1
fi

aws ec2 stop-instances --instance-ids "$INSTANCE_ID" --region "$REGION"
echo "🛑 Instance EC2 arrêtée : $INSTANCE_ID"

# Suppression DNS
./scripts/dns-delete.sh

exit 0
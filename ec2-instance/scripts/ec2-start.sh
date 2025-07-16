#!/bin/bash
cd "$(dirname "$0")/.."

INSTANCE_ID=$(terraform show -json | jq -r '.values.root_module.resources[] | select(.type=="aws_instance") | .values.id')

if [ -z "$INSTANCE_ID" ]; then
  echo "❌ Impossible de trouver l'instance."
  exit 1
fi

REGION=$(terraform output -raw aws_region)

aws ec2 start-instances --instance-ids "$INSTANCE_ID" --region "$REGION"
echo "✅ Instance EC2 démarrée : $INSTANCE_ID"

echo "⏳ Attente de l'IP publique..."
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID" --region "$REGION"

# Attente active que l'IP soit disponible
while true; do
  IP=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --region "$REGION" \
    --query "Reservations[0].Instances[0].PublicIpAddress" \
    --output text)
  
  [[ "$IP" != "None" && -n "$IP" ]] && break
  sleep 2
done

echo "🌐 IP Publique détectée : $IP"

# Mise à jour DNS
./scripts/dns-update.sh

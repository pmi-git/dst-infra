#!/bin/bash
cd "$(dirname "$0")/.."

# Vérifie si l'instance existe dans l'état Terraform
INSTANCE_ID=$(terraform show -json 2>/dev/null | jq -r '
  .values.root_module.resources[]?
  | select(.type == "aws_instance")
  | .values.id
')

if [ -z "$INSTANCE_ID" ] || [ "$INSTANCE_ID" == "null" ]; then
  echo "❌ Aucune instance EC2 actuellement gérée par Terraform."
  exit 0
fi

# Récupère la région
REGION=$(terraform output -raw aws_region 2>/dev/null || echo "us-east-2")

# Vérifie l'état de l'instance via AWS CLI
STATE=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --region "$REGION" \
  --query "Reservations[0].Instances[0].State.Name" \
  --output text 2>/dev/null)

if [ "$STATE" == "terminated" ] || [ "$STATE" == "null" ]; then
  echo "⚠️ L'instance $INSTANCE_ID a été supprimée ou n'existe plus."
  exit 0
fi

echo "🖥️  Instance ID: $INSTANCE_ID"
echo "📍 État actuel : $STATE"

# Si l'instance est active, affiche l'adresse IP publique
if [ "$STATE" == "running" ]; then
  PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --region "$REGION" \
    --query "Reservations[0].Instances[0].PublicIpAddress" \
    --output text)

  echo "🌐 IP Publique : $PUBLIC_IP"
fi

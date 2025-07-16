#!/bin/bash
cd "$(dirname "$0")/.."

INSTANCE_ID=$(terraform show -json | jq -r '.values.root_module.resources[] | select(.type=="aws_instance") | .values.id')

if [ -z "$INSTANCE_ID" ]; then
  echo "❌ Impossible de trouver l'instance. Elle n'est peut-être pas encore créée ?"
  exit 1
fi

aws ec2 stop-instances --instance-ids "$INSTANCE_ID" --region "$(terraform output -raw aws_region)"
echo "🛑 Instance EC2 arrêtée : $INSTANCE_ID"

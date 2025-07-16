#!/bin/bash
cd "$(dirname "$0")/.."
terraform init -input=false
terraform apply -auto-approve
./scripts/dns-update.sh
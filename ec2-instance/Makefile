create:
	@./scripts/ec2-create.sh

destroy:
	@./scripts/ec2-destroy.sh
	@rm -rf .terraform terraform.tfstate terraform.tfstate.backup

status:
	@./scripts/ec2-status.sh

start:
	@./scripts/ec2-start.sh

stop:
	@./scripts/ec2-stop.sh
ssh:
	@IP=$$(terraform output -raw instance_public_ip); \
	KEY_PATH=$$(terraform show -json | jq -r '.values.root_module.variables.public_key_path.value' | sed 's/\.pub$$//'); \
	if [ -z "$$IP" ] || [ "$$IP" = "null" ]; then \
		echo "❌ Impossible de récupérer l'IP. L'instance est peut-être arrêtée ou non créée."; \
		exit 1; \
	fi; \
	echo "🔐 Connexion SSH à ubuntu@$$IP..."; \
	ssh -i "$$KEY_PATH" ubuntu@$$IP


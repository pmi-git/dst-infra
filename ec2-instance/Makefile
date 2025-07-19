# Makefile pour gérer l'infra EC2 + DNS dynamique

.DEFAULT_GOAL := help

help: ## Affiche cette aide
	@echo "🛠️  Commandes disponibles :"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

create: ## Créer l'infrastructure EC2
	@./scripts/ec2-create.sh

destroy: ## Détruire l'infrastructure EC2 et le DNS
	@./scripts/ec2-destroy.sh
	@rm -rf .terraform terraform.tfstate terraform.tfstate.backup

status: ## Afficher l'état de l'instance et du DNS
	@./scripts/ec2-status.sh

start: ## Démarrer l'instance EC2 et mettre à jour le DNS
	@./scripts/ec2-start.sh

stop: ## Arrêter l'instance EC2 et supprimer le DNS
	@./scripts/ec2-stop.sh

ssh: ## Se connecter à l'instance EC2 via SSH
	@IP=$$(terraform output -raw instance_public_ip); \
	KEY_PATH=$$(terraform show -json | jq -r '.values.root_module.variables.public_key_path.value' | sed 's/\.pub$$//'); \
	if [ -z "$$IP" ] || [ "$$IP" = "null" ]; then \
		echo "❌ Impossible de récupérer l'IP."; \
		exit 1; \
	fi; \
	echo "🔐 Connexion SSH à ubuntu@$$IP..."; \
	ssh -i "$$KEY_PATH" ubuntu@$$IP

install_jenkins: ## Installer Jenkins
	@echo "⚙️ Installation de Jenkins via SSH..."
	ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa ubuntu@$$(terraform output -raw instance_public_ip) 'bash -s' < scripts/install_jenkins.sh
	@echo "🔐 Mot de passe initial Jenkins :"
	@ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa ubuntu@$$(terraform output -raw instance_public_ip) 'sudo cat /var/lib/jenkins/secrets/initialAdminPassword'

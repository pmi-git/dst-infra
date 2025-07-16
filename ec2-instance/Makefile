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

dns:
	@./scripts/dns-update.sh

dns-delete:
	@./scripts/dns-delete.sh

destroy-full:
	@make destroy
	@make dns-delete


tf-init:
	terraform init

# Staging
tf-ws-staging:
	terraform workspace select staging

tf-plan-staging: tf-ws-staging tf-init
	terraform plan \
	-var-file="./../environments/staging/config.tfvars.json" \
	-var-file="./../environments/staging/init.tfvars"

tf-apply-staging: tf-ws-staging tf-init
	terraform apply \
	-var-file="./../environments/staging/config.tfvars.json" \
	-var-file="./../environments/staging/init.tfvars"

tf-destroy-staging: tf-ws-staging tf-init
	terraform destroy \
	-var-file="./../environments/staging/config.tfvars.json" \
	-var-file="./../environments/staging/init.tfvars"

# Production
tf-ws-prod:
	terraform workspace select prod

tf-plan-prod: tf-ws-prod tf-init
	terraform plan \
	-var-file="./../environments/prod/config.tfvars.json" \
	-var-file="./../environments/prod/init.tfvars"

tf-apply-prod: tf-ws-prod tf-init
	terraform apply \
	-var-file="./../environments/prod/config.tfvars.json" \
	-var-file="./../environments/prod/init.tfvars"

tf-destroy-prod: tf-ws-prod tf-init
	terraform destroy \
	-var-file="./../environments/prod/config.tfvars.json" \
	-var-file="./../environments/prod/init.tfvars"

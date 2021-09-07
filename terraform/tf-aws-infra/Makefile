ENV?=demo

app_name=$(shell cat ./../environments/$(ENV)/config.tfvars.json | jq -r '.app_name')
env_name=$(shell cat ./../environments/$(ENV)/config.tfvars.json | jq -r '.env_name')
region=$(shell cat ./../environments/$(ENV)/config.tfvars.json | jq -r '.region')
remote_tfstate_bucket=${env_name}-${app_name}-${region}-tfstate

tf-init:
	terraform init \
    -backend-config="bucket=${remote_tfstate_bucket}" \
    -backend-config="key=infrastructure.tfstate" \
    -backend-config="region=${region}"

tf-plan: tf-init
	terraform plan \
	-var-file="./../environments/$(ENV)/config.tfvars.json" \
	-var-file="./../environments/$(ENV)/infra.tfvars"

tf-apply: tf-init
	terraform apply -auto-approve \
	-var-file="./../environments/$(ENV)/config.tfvars.json" \
	-var-file="./../environments/$(ENV)/infra.tfvars"

tf-destroy: tf-init
	terraform destroy -auto-approve \
	-var-file="./../environments/$(ENV)/config.tfvars.json" \
	-var-file="./../environments/$(ENV)/infra.tfvars"
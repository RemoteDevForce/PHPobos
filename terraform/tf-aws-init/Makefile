ENV?=demo
TF_ACTION?=plan

tf-init:
	terraform init

tf-action: tf-init
	terraform $(TF_ACTION) \
	-var-file="./../environments/$(ENV)/config.tfvars" \
	-var-file="./../environments/$(ENV)/init.tfvars"
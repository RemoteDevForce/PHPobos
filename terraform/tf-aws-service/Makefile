ENV?=staging

app_name=$(shell cat ./../environments/common.tfvars.json | jq -r '.app_name')
region=$(shell cat ./../environments/$(ENV)/config.tfvars.json | jq -r '.region')
remote_tfstate_bucket=${ENV}-${app_name}-${region}-tfstate

tf-init:
	terraform init \
    -backend-config="bucket=${remote_tfstate_bucket}" \
    -backend-config="key=ecs-app-service.tfstate" \
    -backend-config="region=${region}"

tf-plan: tf-init
	terraform plan \
	-var-file="./../environments/common.tfvars.json" \
	-var-file="./../environments/$(ENV)/config.tfvars.json" \
	-var-file="./../environments/$(ENV)/service.tfvars" \
	-var-file="./last-$(ENV)-build.tfvars" \
	-var="env_name=$(ENV)"

tf-apply: tf-init
	terraform apply -auto-approve \
	-var-file="./../environments/common.tfvars.json" \
	-var-file="./../environments/$(ENV)/config.tfvars.json" \
	-var-file="./../environments/$(ENV)/service.tfvars" \
	-var-file="./last-$(ENV)-build.tfvars" \
	-var="env_name=$(ENV)"
# To rollback, remove the #last-*-build.tfvars input above and
# get the previous commit hash and uncomment the lines below.
# paste that hash as the docker_tag along with the target ECR repo to image_name below.
#	-var="docker_tag=d1f59dca824c111fe06a47d82d2a18be4505f69f"
#	-var="image_name=128572894824.dkr.ecr.us-west-2.amazonaws.com/staging-phpobos-ecr"\
# Checkout your s3 bucket and download the file for all these details if needed

tf-destroy: tf-init
	terraform destroy -auto-approve \
	-var-file="./../environments/common.tfvars.json" \
	-var-file="./../environments/$(ENV)/config.tfvars.json" \
	-var-file="./../environments/$(ENV)/service.tfvars" \
	-var-file="./last-$(ENV)-build.tfvars" \
	-var="env_name=$(ENV)"
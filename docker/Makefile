ENV?=staging
IMAGE_TAG?=latest

chk-registry:
ifndef ECR_REGISTRY
	$(error ECR_REGISTRY is undefined)
endif

chk-ecr-repo:
ifndef ECR_REPOSITORY
	$(error ECR_REPOSITORY is undefined)
endif

chk-image-tag:
ifndef ECR_REPOSITORY
	$(error ECR_REPOSITORY is undefined)
endif

build-and-push: build-image push-image

build-image: chk-registry chk-ecr-repo chk-image-tag
	cp -R ../app ./files/var/www
	echo "docker build -t ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
	docker build -t ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG} ./

push-image: chk-registry chk-ecr-repo chk-image-tag
	echo "docker tag ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG} ${ECR_REGISTRY}/${ECR_REPOSITORY}:latest"
	docker tag ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG} ${ECR_REGISTRY}/${ECR_REPOSITORY}:latest
	docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}
	docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:latest

down:
	docker-compose down

logs:
	docker-compose logs -f

up:
	docker-compose up -d --force-recreate --build

ssh:
	docker-compose exec app /bin/bash

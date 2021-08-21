ENV?=demo
DOCKER_TAG_NAME?=latest

check-img-name:
ifndef DOCKER_REGISTRY
	$(error DOCKER_REGISTRY is undefined)
endif

build-prod-image: check-img-name
	cp -R ../app ./files/var/www
	echo "docker build -t ${DOCKER_IMAGE_NAME}:${ENV}_${DOCKER_TAG_NAME}"
	docker build -t ${DOCKER_IMAGE_NAME}:${ENV}_${$DOCKER_TAG_NAME} ./

down:
	docker-compose down

logs:
	docker-compose logs -f

up:
	docker-compose up -d --force-recreate --build